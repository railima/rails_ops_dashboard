# frozen_string_literal: true

module RailsOpsDashboard
  class EnvironmentsController < BaseController
    def show
      @env_vars = ENV.sort
      @metadata = {
        rails_env: Rails.env,
        hostname: Socket.gethostname,
        ruby_version: RUBY_VERSION,
        rails_version: Rails.version,
        pid: Process.pid
      }
    end
  end
end
