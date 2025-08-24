require_relative 'base'

module QuickCount
  module Adapters
    class Mysql < Base
      def supported?
        connection.adapter_name.downcase.match?(/mysql/)
      end

      def install(threshold: 500_000)
        # MySQL doesn't need function installation - uses built-in INFORMATION_SCHEMA
        @threshold = threshold
      end

      def uninstall
        # MySQL doesn't need function cleanup
      end

      def quick_count(table_name, threshold: nil)
        threshold = threshold || @threshold || 500_000
        
        # Get estimated count from INFORMATION_SCHEMA
        estimated_count = get_table_rows_estimate(table_name)
        
        if estimated_count < threshold
          # Use exact count for small tables
          result = execute_sql("SELECT COUNT(*) as count FROM #{quote_identifier(table_name)}")
          result[0]['count'].to_i
        else
          estimated_count
        end
      end

      def count_estimate(query)
        # Use EXPLAIN to get row estimate
        result = execute_sql("EXPLAIN #{query}")
        
        # Parse the rows from EXPLAIN output
        # MySQL EXPLAIN returns different formats, try to extract rows estimate
        if result.respond_to?(:each)
          result.each do |row|
            if row['rows']
              return row['rows'].to_i
            elsif row['Extra'] && row['Extra'].match(/rows=(\d+)/)
              return $1.to_i
            end
          end
        end
        
        # Fallback: try to extract from query if it's a simple SELECT
        if query.match(/FROM\s+(\w+)/i)
          table_name = $1
          return get_table_rows_estimate(table_name)
        end
        
        # Last resort - return 0
        0
      end

      private

      def default_schema
        connection.current_database
      end

      def get_table_rows_estimate(table_name)
        database_name = connection.current_database
        
        # Try INNODB_TABLESTATS first (more accurate for InnoDB)
        result = execute_sql(<<~SQL)
          SELECT NUM_ROWS 
          FROM INFORMATION_SCHEMA.INNODB_TABLESTATS 
          WHERE NAME = '#{database_name}/#{table_name}'
        SQL
        
        if result && result.first && result.first['NUM_ROWS']
          return result.first['NUM_ROWS'].to_i
        end
        
        # Fallback to INFORMATION_SCHEMA.TABLES
        result = execute_sql(<<~SQL)
          SELECT TABLE_ROWS 
          FROM INFORMATION_SCHEMA.TABLES 
          WHERE TABLE_SCHEMA = '#{database_name}' 
          AND TABLE_NAME = '#{table_name}'
        SQL
        
        if result && result.first && result.first['TABLE_ROWS']
          result.first['TABLE_ROWS'].to_i
        else
          0
        end
      end
    end
  end
end