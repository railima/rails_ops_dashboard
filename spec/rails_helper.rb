# frozen_string_literal: true

ENV['RAILS_ENV'] = 'test'

require_relative 'dummy/config/application'
Rails.application.initialize!

require 'rspec/rails'
require_relative 'support/auth_helper'

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!

  config.after do
    RailsOpsDashboard.reset_configuration!
    RailsOpsDashboard.configure do |c|
      c.username = 'admin'
      c.password = 'secret'
      c.blocked_environments = %w[production]
    end
  end
end
