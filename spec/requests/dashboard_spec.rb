# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dashboard', type: :request do
  describe 'GET /ops' do
    it 'renders dashboard with stats' do
      get '/ops', headers: ops_headers

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Seeds')
      expect(response.body).to include('Rake Tasks')
    end

    it 'renders environment banner' do
      get '/ops', headers: ops_headers
      expect(response.body).to include('TEST')
    end

    it 'renders sidebar navigation' do
      get '/ops', headers: ops_headers
      expect(response.body).to include('Dashboard')
      expect(response.body).to include('Environment')
      expect(response.body).to include('Seeds')
      expect(response.body).to include('Rake Tasks')
    end

    it 'renders logout button' do
      get '/ops', headers: ops_headers
      expect(response.body).to include('Logout')
    end
  end

  describe 'DELETE /ops/logout' do
    it 'returns 401 to clear browser credentials' do
      delete '/ops/logout'
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
