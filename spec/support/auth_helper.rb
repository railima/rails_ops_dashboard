# frozen_string_literal: true

module OpsAuthHelper
  def ops_headers
    credentials = ActionController::HttpAuthentication::Basic.encode_credentials('admin', 'secret')
    { 'HTTP_AUTHORIZATION' => credentials }
  end
end

RSpec.configure do |config|
  config.include OpsAuthHelper, type: :request
end
