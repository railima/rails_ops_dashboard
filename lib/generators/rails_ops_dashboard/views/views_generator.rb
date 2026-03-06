# frozen_string_literal: true

module RailsOpsDashboard
  module Generators
    class ViewsGenerator < Rails::Generators::Base
      desc 'Copies RailsOpsDashboard views to your application for customization.'

      def copy_views
        directory engine_views_path, Rails.root.join('app/views/rails_ops_dashboard')
      end

      private

      def engine_views_path
        File.expand_path('../../../../app/views/rails_ops_dashboard', __dir__)
      end
    end
  end
end
