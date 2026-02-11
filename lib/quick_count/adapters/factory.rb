require_relative 'postgresql'
require_relative 'mysql'

module QuickCount
  module Adapters
    class Factory
      ADAPTERS = [Postgresql, Mysql].freeze

      def self.create(connection:)
        adapter_class = detect_adapter(connection)

        unless adapter_class
          raise UnsupportedDatabaseError, "Unsupported database: #{connection.adapter_name}"
        end

        adapter_class.new(connection: connection)
      end

      def self.detect_adapter(connection)
        ADAPTERS.find { |adapter_class| adapter_class.new(connection: connection).supported? }
      end

      def self.supported_databases
        ADAPTERS.map do |adapter_class|
          adapter_class.name.split('::').last.downcase
        end
      end
    end

    class UnsupportedDatabaseError < StandardError; end
  end
end
