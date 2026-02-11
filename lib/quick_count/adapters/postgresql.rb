require_relative 'base'

module QuickCount
  module Adapters
    class Postgresql < Base
      def supported?
        connection.adapter_name.downcase.match?(/postg/)
      end

      def quick_count(table_name, threshold: nil)
        threshold ||= 500_000

        # Use direct SQL estimation without needing functions
        estimated_count = get_table_estimate(table_name)

        if estimated_count < threshold
          # Use exact count for small tables
          result = execute_sql("SELECT COUNT(*) as count FROM #{quote_identifier(table_name)}")
          result[0]['count'].to_i
        else
          estimated_count
        end
      end

      def count_estimate(query)
        # Use EXPLAIN to get row estimate directly
        result = execute_sql("EXPLAIN #{query}")

        # Parse the rows from EXPLAIN output
        if result.respond_to?(:each)
          result.each do |row|
            if row['QUERY PLAN'] && row['QUERY PLAN'].match(/rows=(\d+)/)
              return $1.to_i
            end
          end
        end

        # Fallback: return 0 if we can't parse
        0
      end

      private

      def get_table_estimate(table_name)
        # Enhanced estimation using both reltuples and live stats
        result = execute_sql(<<~SQL)
          SELECT COALESCE(
            -- Prefer live statistics when available
            pg_stat.n_live_tup,
            -- Fall back to enhanced planner-style estimation
            CASE
              WHEN pg_class.reltuples < 0 THEN NULL -- never vacuumed
              WHEN pg_class.relpages = 0 THEN 0     -- empty table
              ELSE (pg_class.reltuples / GREATEST(pg_class.relpages, 1)) *
                   (pg_relation_size(pg_class.oid) / current_setting('block_size')::int)
            END
          )::bigint AS estimated_count
          FROM pg_class
          LEFT JOIN pg_stat_user_tables pg_stat ON pg_stat.relid = pg_class.oid
          WHERE pg_class.oid = '#{table_name}'::regclass

          -- Handle partitioned tables
          UNION ALL
          SELECT sum(
            COALESCE(
              pg_stat.n_live_tup,
              (pg_class.reltuples/GREATEST(pg_class.relpages,1)) *
              (pg_relation_size(pg_class.oid)/current_setting('block_size')::int)
            )
          )::bigint as estimated_count
          FROM pg_inherits
          JOIN pg_class ON pg_inherits.inhrelid = pg_class.oid
          LEFT JOIN pg_stat_user_tables pg_stat ON pg_stat.relid = pg_class.oid
          WHERE pg_inherits.inhparent = '#{table_name}'::regclass
        SQL

        # Get the maximum estimate (handles both regular and partitioned tables)
        estimates = result.map { |row| row['estimated_count']&.to_i || 0 }
        estimates.max || 0
      end
    end
  end
end
