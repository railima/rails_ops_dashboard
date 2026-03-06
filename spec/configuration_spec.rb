# frozen_string_literal: true

require 'spec_helper'
require 'rails_ops_dashboard/configuration'

RSpec.describe RailsOpsDashboard::Configuration do
  subject(:config) { described_class.new }

  describe 'defaults' do
    it 'has default username' do
      expect(config.username).to eq('admin')
    end

    it 'has default password' do
      expect(config.password).to eq('password')
    end

    it 'blocks production by default' do
      expect(config.blocked_environments).to eq(%w[production])
    end

    it 'has default seeds_path' do
      expect(config.seeds_path).to eq('app/services/database_update')
    end

    it 'has default seeds_base_class' do
      expect(config.seeds_base_class).to eq('DatabaseUpdate')
    end

    it 'has default seeds_executor' do
      expect(config.seeds_executor).to be_a(Proc)
    end

    it 'has default rake_tasks_path' do
      expect(config.rake_tasks_path).to eq('lib/tasks')
    end

    it 'has empty plugins by default' do
      expect(config.plugins).to eq({})
    end
  end

  describe '#plugin' do
    it 'registers a plugin by symbol' do
      config.plugin :workers, workers: []
      expect(config.plugins).to have_key(:workers)
    end

    it 'stores plugin options' do
      config.plugin :workers, workers: [{ id: 'test' }]
      expect(config.plugins[:workers][:workers]).to eq([{ id: 'test' }])
    end
  end
end

RSpec.describe RailsOpsDashboard do
  describe '.configure' do
    after { RailsOpsDashboard.reset_configuration! }

    it 'yields a configuration object' do
      RailsOpsDashboard.configure do |c|
        expect(c).to be_a(RailsOpsDashboard::Configuration)
      end
    end

    it 'stores configuration' do
      RailsOpsDashboard.configure do |c|
        c.username = 'custom_user'
      end
      expect(RailsOpsDashboard.configuration.username).to eq('custom_user')
    end
  end
end
