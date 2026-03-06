# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Seeds', type: :request do
  describe 'GET /ops/seeds' do
    it 'requires authentication' do
      get '/ops/seeds'
      expect(response).to have_http_status(:unauthorized)
    end

    it 'lists discovered seed classes' do
      get '/ops/seeds', headers: ops_headers

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('DatabaseUpdate::AddTestData')
    end
  end

  describe 'POST /ops/seeds/execute' do
    it 'rejects classes outside configured namespace' do
      post '/ops/seeds/execute', params: { class_name: 'String' }, headers: ops_headers

      expect(response).to have_http_status(:redirect)
      expect(response.location).to include('error')
    end

    it 'rejects classes with no matching file' do
      post '/ops/seeds/execute', params: { class_name: 'DatabaseUpdate::NonExistent' }, headers: ops_headers

      expect(response).to have_http_status(:redirect)
    end

    it 'starts a valid seed in background' do
      allow_any_instance_of(RailsOpsDashboard::SeedsController).to receive(:run_in_background) # rubocop:disable RSpec/AnyInstance

      post '/ops/seeds/execute', params: { class_name: 'DatabaseUpdate::AddTestData' }, headers: ops_headers

      expect(response).to have_http_status(:redirect)
      expect(response.location).to include('task_id=')
    end
  end

  describe 'GET /ops/seeds/status' do
    it 'returns not_found for unknown task' do
      get '/ops/seeds/status', params: { task_id: 'nonexistent' }, headers: ops_headers

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body['status']).to eq('not_found')
    end
  end
end
