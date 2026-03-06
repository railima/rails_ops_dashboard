# frozen_string_literal: true

module RailsOpsDashboard
  class Plugin
    class << self
      def nav_items
        @nav_items ||= []
      end

      def nav_item(label, path:)
        nav_items << { label: label, path: path }
      end

      def config_options
        @config_options ||= {}
      end

      def config_option(name, default: nil)
        config_options[name] = default
      end
    end
  end
end
