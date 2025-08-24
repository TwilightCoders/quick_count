ENV['RAILS_ENV'] = 'test'

require 'database_cleaner'
require 'combustion'
require 'simplecov'

if ENV['COVERAGE']
  require 'simplecov-json'
  SimpleCov.start do
    add_filter 'spec'

    # Generate both HTML and JSON for CI
    SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
                                                                      SimpleCov::Formatter::HTMLFormatter,
                                                                      SimpleCov::Formatter::JSONFormatter
                                                                    ])
  end
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
