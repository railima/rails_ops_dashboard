# frozen_string_literal: true

RailsOpsDashboard.configure do |config|
  config.username = 'admin'
  config.password = 'secret'
  config.blocked_environments = %w[production]
end
