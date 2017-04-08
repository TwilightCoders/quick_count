require 'active_support/concern'

module QuickCount
  module ActiveRecord
    module Base
      extend ActiveSupport::Concern

      module ClassMethods

        def quick_count
          result = ::ActiveRecord::Base.connection.execute("SELECT quick_count('#{table_name}')")
          result[0]["quick_count"]
        end

      end

    end
  end
end
