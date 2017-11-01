ENV["RAILS_ENV"] = "test"

require 'database_cleaner'

require 'simplecov'
SimpleCov.start do
  # add_group 'Lib', 'lib'
  add_filter 'spec'
end

require 'quick_count'

Dir[QuickCount.root.join('spec/support/**/*.rb')].each { |f| require f }

db_config = {
  adapter: "postgresql", database: "quick_count_test"
}

db_config_admin = db_config.merge({ database: 'postgres', schema_search_path: 'public' })

ActiveRecord::Base.establish_connection db_config_admin
ActiveRecord::Base.connection.drop_database(db_config[:database])
ActiveRecord::Base.connection.create_database(db_config[:database])
ActiveRecord::Base.establish_connection db_config

load File.dirname(__FILE__) + '/schema.rb'

QuickCount.load
QuickCount.install

RSpec.configure do |config|
  config.order = "random"

end
