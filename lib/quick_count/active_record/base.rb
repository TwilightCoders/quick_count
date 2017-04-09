require 'active_support/concern'

module QuickCount
  module ActiveRecord
    module Base
      extend ActiveSupport::Concern

      module ClassMethods

        def quick_count
          result = ::ActiveRecord::Base.connection.execute("SELECT quick_count('#{table_name}')")
          result[0]["quick_count"].to_i
        end

        def count_estimate
          my_statement = ::ActiveRecord::Base.connection.quote(to_sql)
          result = ::ActiveRecord::Base.connection.execute("SELECT count_estimate(#{my_statement})")
          result[0]["count_estimate"]
        end

      end

    end
  end
end
