require 'active_support/concern'

module QuickCount
  module ActiveRecord
    extend ActiveSupport::Concern

    module ClassMethods
      def quick_count(threshold: nil)
        QuickCount.quick_count(table_name, threshold: threshold, connection: connection)
      end
    end

    # Instance method for ActiveRecord::Relation
    def count_estimate
      QuickCount.count_estimate(to_sql, connection: connection)
    end
  end
end
