# frozen_string_literal: true

module RailsOpsDashboard
  class SessionsController < BaseController
    skip_before_action :authenticate, only: [:destroy]

    def destroy
      head :unauthorized
    end
  end
end
