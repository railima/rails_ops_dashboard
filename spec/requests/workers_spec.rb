# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Workers', type: :request do
  describe 'when plugin is not enabled' do
    before do
      RailsOpsDashboard.configure do |config|
        config.username = 'admin'
        config.password = 'secret'
      end
    end

    after { RailsOpsDashboard.reset_configuration! }

    it 'redirects to root' do
      get '/ops/workers', headers: ops_headers
      expect(response).to have_http_status(:redirect)
    end
  end

  describe 'when plugin is enabled' do
    before do
      RailsOpsDashboard.configure do |config|
        config.username = 'admin'
        config.password = 'secret'
        config.plugin :workers,
                      development_only: false,
                      workers: [
                        { id: 'test_worker', name: 'Test Worker', command: 'echo hello' }
                      ]
      end
    end

    after { RailsOpsDashboard.reset_configuration! }

    it 'lists configured workers' do
      get '/ops/workers', headers: ops_headers

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Test Worker')
      expect(response.body).to include('echo hello')
    end

    it 'shows workers nav item in sidebar' do
      get '/ops/workers', headers: ops_headers

      expect(response.body).to include('Workers')
    end
  end
end
