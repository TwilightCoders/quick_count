require 'active_support/concern'
require 'pry'

module CountEstimate
  module ActiveRecord

    def count_estimate
      my_statement = connection.quote(to_sql)
      result = connection.execute("SELECT count_estimate(#{my_statement})")
      result[0]["count_estimate"].to_i
    end

  end
end
