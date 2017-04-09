require 'active_support/concern'

module CountEstimate
  module ActiveRecord
    module Relation

      def count_estimate
        my_statement = ::ActiveRecord::Base.connection.quote(to_sql)
        result = ::ActiveRecord::Base.connection.execute("SELECT count_estimate(#{my_statement})")
        result[0]["count_estimate"].to_i
      end

    end
  end
end
