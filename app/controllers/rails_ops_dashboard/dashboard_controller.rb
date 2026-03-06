# frozen_string_literal: true

module RailsOpsDashboard
  class DashboardController < BaseController
    def index
      config = RailsOpsDashboard.configuration
      seeds_path = Rails.root.join(config.seeds_path, '*.rb')
      rake_tasks_path = config.rake_tasks_path

      Rails.application.load_tasks
      rake_count = Rake::Task.tasks.count { |t| t.locations.any? { |l| l.include?(rake_tasks_path) } }

      @stats = {
        seeds: Dir.glob(seeds_path).count,
        rake_tasks: rake_count
      }
    end
  end
end
