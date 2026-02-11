module QuickCount
  module Adapters
    class Base
      attr_reader :connection

      def initialize(connection:)
        @connection = connection
      end

      # Abstract methods that must be implemented by adapters
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
