require 'rails/railtie'
require 'quick_count/active_record'

module QuickCount
  class Railtie < Rails::Railtie
    initializer 'quick_count.load' do |app|
      ActiveSupport.on_load(:active_record) do
        QuickCount.load
      end
    end
  end
end
