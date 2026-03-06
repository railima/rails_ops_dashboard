# frozen_string_literal: true

require 'rails'
require 'action_controller/railtie'

module Dummy
  class Application < Rails::Application
    config.eager_load = false
    config.hosts.clear
  end
end
