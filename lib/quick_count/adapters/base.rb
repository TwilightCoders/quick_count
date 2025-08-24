module QuickCount
  module Adapters
    class Base
      attr_reader :connection, :schema

      def initialize(connection:, schema: default_schema)
        @connection = connection
        @schema = schema
      end

      # Abstract methods that must be implemented by adapters
      def install(threshold: 500_000)
        raise NotImplementedError, "#{self.class} must implement #install"
      end

      def uninstall
        raise NotImplementedError, "#{self.class} must implement #uninstall"
      end

      def quick_count(table_name, threshold: nil)
        raise NotImplementedError, "#{self.class} must implement #quick_count"
      end

      def count_estimate(query)
        raise NotImplementedError, "#{self.class} must implement #count_estimate"
      end

      def supported?
        raise NotImplementedError, "#{self.class} must implement #supported?"
      end

      private

      def default_schema
        'public'
      end

      def execute_sql(sql)
        connection.execute(sql)
      end

      def quote_identifier(identifier)
        connection.quote_column_name(identifier)
      end

      def quote_value(value)
        connection.quote(value)
      end
    end
  end
end
