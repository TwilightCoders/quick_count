ENV['RAILS_ENV'] = 'test'

require 'database_cleaner'
require 'combustion'
require 'simplecov'

SimpleCov.start do
  add_filter 'spec'
end

Combustion.path = 'spec/support/rails'
Combustion.initialize! :active_record

schema = "quick_count"

RSpec.configure do |config|
  config.order = "random"

  config.before(:suite) do
    ActiveRecord::Base.connection.execute("CREATE SCHEMA #{schema}")
    QuickCount.install(schema: schema)
  end

  config.after(:suite) do
    QuickCount.uninstall(schema: schema)
    ActiveRecord::Base.connection.execute("DROP SCHEMA #{schema}")
  end

end
