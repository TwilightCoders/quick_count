require 'quick_count/version'
require 'quick_count/railtie'
require 'quick_count/adapters/factory'
require 'active_record'

module QuickCount
  def self.root
    @root ||= Pathname.new(File.dirname(File.expand_path(File.dirname(__FILE__), '/../')))
  end

  def self.load
    ::ActiveRecord::Base.include QuickCount::ActiveRecord
    ::ActiveRecord::Relation.include QuickCount::ActiveRecord
  end

  def self.quick_count(table_name, threshold: nil, connection: ::ActiveRecord::Base.connection)
    adapter = create_adapter(connection: connection)
    adapter.quick_count(table_name, threshold: threshold)
  end

  def self.count_estimate(query, connection: ::ActiveRecord::Base.connection)
    adapter = create_adapter(connection: connection)
    adapter.count_estimate(query)
  end

  def self.supported_databases
    Adapters::Factory.supported_databases
  end

  private

  def self.create_adapter(connection:)
    Adapters::Factory.create(connection: connection)
  end
end
