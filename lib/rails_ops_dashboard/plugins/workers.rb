# frozen_string_literal: true

module RailsOpsDashboard
  module Plugins
    class Workers < RailsOpsDashboard::Plugin
      nav_item 'Workers', path: :workers_path
      config_option :workers, default: []
      config_option :development_only, default: true
    end
  end
end
