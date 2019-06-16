require 'quick_count/version'
require 'quick_count/railtie'
require 'active_record'

module QuickCount

  def self.root
    @root ||= Pathname.new(File.dirname(File.expand_path(File.dirname(__FILE__), '/../')))
  end

  def self.load
    ::ActiveRecord::Base.send :include, QuickCount::ActiveRecord
    ::ActiveRecord::Relation.send :include, CountEstimate::ActiveRecord
  end

  def self.install(threshold: 500000, schema: 'public')
    ::ActiveRecord::Base.connection.execute(quick_count_sql(schema: schema, threshold: threshold))
    ::ActiveRecord::Base.connection.execute(count_estimate_sql(schema: schema))
  end

  def self.uninstall(schema: 'public')
    ::ActiveRecord::Base.connection.execute("DROP FUNCTION IF EXISTS #{schema}.quick_count(text, bigint);")
    ::ActiveRecord::Base.connection.execute("DROP FUNCTION IF EXISTS #{schema}.quick_count(text);")
    ::ActiveRecord::Base.connection.execute("DROP FUNCTION IF EXISTS #{schema}.count_estimate(text);")
  end

private

  def self.quick_count_sql(threshold: 500000, schema: 'public')
    <<~SQL
      CREATE OR REPLACE FUNCTION #{schema}.quick_count(table_name text, threshold bigint default #{threshold}) RETURNS bigint AS
      $func$
      DECLARE count bigint;
      BEGIN
        EXECUTE 'SELECT
          CASE
          WHEN SUM(estimate)::integer < '|| threshold ||' THEN
            (SELECT COUNT(*) FROM "'|| table_name ||'")
          ELSE
            SUM(estimate)::integer
          END AS count
        FROM (
          SELECT
              ((SUM(child.reltuples::float)/greatest(SUM(child.relpages::float),1))) * (SUM(pg_relation_size(child.oid))::float / (current_setting(''block_size'')::float)) AS estimate
          FROM pg_inherits
              JOIN pg_class parent ON pg_inherits.inhparent = parent.oid
              JOIN pg_class child  ON pg_inherits.inhrelid  = child.oid
          WHERE parent.relname = '''|| table_name ||'''
          UNION SELECT (reltuples::float/greatest(relpages::float, 1)) * (pg_relation_size(pg_class.oid)::float / (current_setting(''block_size'')::float)) AS estimate FROM pg_class where relname='''|| table_name ||'''
        ) AS tables' INTO count;
        RETURN count;
      END
      $func$ LANGUAGE plpgsql;
    SQL
  end

  def self.count_estimate_sql(schema: 'public')
    <<~SQL
      CREATE OR REPLACE FUNCTION #{schema}.count_estimate(query text) RETURNS integer AS
      $func$
      DECLARE
        rec   record;
        rows  integer;
      BEGIN
        FOR rec IN EXECUTE 'EXPLAIN ' || query LOOP
          rows := substring(rec."QUERY PLAN" FROM ' rows=([[:digit:]]+)');
          EXIT WHEN rows IS NOT NULL;
        END LOOP;
        RETURN rows;
      END
      $func$ LANGUAGE plpgsql;
    SQL
  end

end

