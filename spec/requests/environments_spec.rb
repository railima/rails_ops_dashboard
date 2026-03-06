# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Environment', type: :request do
  describe 'GET /ops/environment' do
    it 'requires authentication' do
      get '/ops/environment'
      expect(response).to have_http_status(:unauthorized)
    end

    it 'lists environment variables' do
      ENV['TEST_OPS_VAR'] = 'test_value_xyz'

      get '/ops/environment', headers: ops_headers

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('TEST_OPS_VAR')
      expect(response.body).to include('test_value_xyz')
    ensure
      ENV.delete('TEST_OPS_VAR')
    end

    it 'shows metadata' do
      get '/ops/environment', headers: ops_headers

      expect(response.body).to include(Rails.env)
      expect(response.body).to include(RUBY_VERSION)
      expect(response.body).to include(Rails.version)
    end
  end
end
