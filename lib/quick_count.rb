require 'quick_count/railtie'
require 'active_record'
require 'rake'

module QuickCount

  def self.root
    @root ||= Pathname.new(File.dirname(File.expand_path(File.dirname(__FILE__), '/../')))
  end

  def self.load
    ::ActiveRecord::Base.send :include, QuickCount::ActiveRecord::Base
  end

  def self.install
    ::ActiveRecord::Base.connection.execute(<<-eos
      CREATE OR REPLACE FUNCTION quick_count(table_name text) RETURNS bigint AS
      $func$
      DECLARE
          rec   record;
          rows  integer;
      BEGIN
        RETURN (SELECT SUM(estimate) AS estimate FROM (
        SELECT
            SUM(child.reltuples::bigint) AS estimate
        FROM pg_inherits
            JOIN pg_class parent            ON pg_inherits.inhparent = parent.oid
            JOIN pg_class child             ON pg_inherits.inhrelid   = child.oid
            JOIN pg_namespace nmsp_parent   ON nmsp_parent.oid  = parent.relnamespace
            JOIN pg_namespace nmsp_child    ON nmsp_child.oid   = child.relnamespace
        WHERE parent.relname = table_name
        GROUP BY parent.reltuples
        UNION SELECT reltuples::bigint AS estimate FROM pg_class where relname=table_name) as tables);
      END
      $func$ LANGUAGE plpgsql;
    eos
    )
  end

  def self.uninstall
    ::ActiveRecord::Base.connection.execute("DROP FUNCTION quick_count(text);")
  end

end

