require 'spec_helper'

describe QuickCount::Adapters do
  describe 'Factory' do
    it 'detects PostgreSQL adapter' do
      adapter = QuickCount::Adapters::Factory.create(connection: ActiveRecord::Base.connection)
      expect(adapter).to be_a(QuickCount::Adapters::Postgresql)
    end

    it 'lists supported databases' do
      databases = QuickCount.supported_databases
      expect(databases).to include('postgresql')
      expect(databases).to include('mysql')
    end
  end

  describe 'PostgreSQL Adapter' do
    let(:adapter) { QuickCount::Adapters::Factory.create(connection: ActiveRecord::Base.connection) }

    it 'supports PostgreSQL' do
      expect(adapter.supported?).to be true
    end

    it 'provides quick_count functionality via QuickCount module' do
      # Test via the main interface which handles schema properly
      result = QuickCount.quick_count('posts')
      expect(result).to be >= 0
    end

    it 'provides count_estimate functionality via QuickCount module' do
      # Test via the main QuickCount interface to ensure proper schema handling
      result = QuickCount.count_estimate('SELECT * FROM posts')
      expect(result).to be >= 0
    end
  end
end
