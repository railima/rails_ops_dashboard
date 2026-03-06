# frozen_string_literal: true

require 'rails'
require 'action_controller/railtie'
require 'rails_ops_dashboard'

module Dummy
  class Application < Rails::Application
    config.root = File.expand_path('../..', __FILE__)
    config.eager_load = false
    config.hosts.clear
  end
end
