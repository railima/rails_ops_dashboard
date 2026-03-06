# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Rake Tasks', type: :request do
  describe 'GET /ops/rake_tasks' do
    it 'requires authentication' do
      get '/ops/rake_tasks'
      expect(response).to have_http_status(:unauthorized)
    end

    it 'lists custom rake tasks' do
      get '/ops/rake_tasks', headers: ops_headers

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('test_ops:greet')
    end
  end

  describe 'POST /ops/rake_tasks/execute' do
    it 'rejects non-existent tasks' do
      post '/ops/rake_tasks/execute', params: { task_name: 'nonexistent:task' }, headers: ops_headers

      expect(response).to have_http_status(:redirect)
    end

    it 'rejects built-in Rails tasks' do
      post '/ops/rake_tasks/execute', params: { task_name: 'db:migrate' }, headers: ops_headers

      expect(response).to have_http_status(:redirect)
    end
  end

  describe 'GET /ops/rake_tasks/status' do
    it 'returns not_found for unknown task' do
      get '/ops/rake_tasks/status', params: { task_id: 'nonexistent' }, headers: ops_headers

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body['status']).to eq('not_found')
    end
  end
end
