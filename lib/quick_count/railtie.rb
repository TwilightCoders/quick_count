require 'rails/railtie'
require 'quick_count/active_record'
require 'count_estimate/active_record'

module QuickCount
  class Railtie < Rails::Railtie

    # rake_tasks do
    #   load "../tasks/quick_count_tasks.rake"
    # end

    initializer 'quick_count.load' do |app|
      ActiveSupport.on_load(:active_record) do
        QuickCount.load
      end
    end

  end
end
