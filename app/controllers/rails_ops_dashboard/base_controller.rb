# frozen_string_literal: true

module RailsOpsDashboard
  class BaseController < ActionController::Base # rubocop:disable Rails/ApplicationController
    skip_forgery_protection
    before_action :block_environment!
    before_action :authenticate
    layout 'rails_ops_dashboard/application'

    private

    def block_environment!
      head :not_found if RailsOpsDashboard.configuration.blocked_environments.include?(Rails.env)
    end

    def authenticate
      config = RailsOpsDashboard.configuration
      authenticate_or_request_with_http_basic('Ops Dashboard') do |username, password|
        ActiveSupport::SecurityUtils.secure_compare(username, config.username) &
          ActiveSupport::SecurityUtils.secure_compare(password, config.password)
      end
    end
  end
end
