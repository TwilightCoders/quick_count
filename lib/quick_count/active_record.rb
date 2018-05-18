require 'active_support/concern'

module QuickCount
  module ActiveRecord
    extend ActiveSupport::Concern

    module ClassMethods

      def quick_count(threshold: nil)
        threshold = threshold ? ", #{threshold}" : nil
        result = ::ActiveRecord::Base.connection.execute("SELECT quick_count('#{table_name}'#{threshold})")
        result[0]["quick_count"].to_i
      end

    end

  end
end
