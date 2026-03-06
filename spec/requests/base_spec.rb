# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Base authentication', type: :request do
  describe 'authentication' do
    it 'returns 401 without credentials' do
      get '/ops'
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns 401 with wrong credentials' do
      bad = ActionController::HttpAuthentication::Basic.encode_credentials('wrong', 'creds')
      get '/ops', headers: { 'HTTP_AUTHORIZATION' => bad }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns 200 with valid credentials' do
      get '/ops', headers: ops_headers
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'environment blocking' do
    it 'returns 404 in blocked environment' do
      allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('production'))
      get '/ops', headers: ops_headers
      expect(response).to have_http_status(:not_found)
    end
  end
end
