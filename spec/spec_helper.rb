ENV['RAILS_ENV'] = 'test'

require 'logger'
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

RSpec.configure do |config|
  config.order = "random"
end
