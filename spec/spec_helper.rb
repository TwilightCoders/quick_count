ENV['RAILS_ENV'] = 'test'

require 'database_cleaner'
require 'combustion'

require 'simplecov'
SimpleCov.start do
  add_filter 'spec'
end

Combustion.path = 'spec/support/rails'
Combustion.initialize! :active_record

RSpec.configure do |config|
  config.order = "random"

  config.before(:suite) do
    QuickCount.install
  end

  config.after(:suite) do
    QuickCount.uninstall
  end

end
