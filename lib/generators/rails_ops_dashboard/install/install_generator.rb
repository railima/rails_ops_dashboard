# frozen_string_literal: true

module RailsOpsDashboard
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      desc 'Creates a RailsOpsDashboard initializer and mounts the engine in routes.'

      def copy_initializer
        template 'initializer.rb.tt', 'config/initializers/rails_ops_dashboard.rb'
      end

      def mount_engine
        route "mount RailsOpsDashboard::Engine, at: '/ops'"
      end
    end
  end
end
