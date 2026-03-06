# frozen_string_literal: true

module RailsOpsDashboard
  module BackgroundTaskRunner
    extend ActiveSupport::Concern

    TASKS = Concurrent::Map.new

    def run_in_background(task_id, task_name)
      TASKS[task_id] = { name: task_name, status: 'running', started_at: Time.current.iso8601 }

      Thread.new do
        yield
        TASKS[task_id][:status] = 'completed'
      rescue StandardError => e
        TASKS[task_id][:status] = 'failed'
        TASKS[task_id][:error] = e.message
        Rails.logger.error("[RailsOpsDashboard] Task #{task_name} failed: #{e.message}")
      ensure
        TASKS[task_id][:finished_at] = Time.current.iso8601
      end
    end

    def task_status(task_id)
      TASKS[task_id]
    end
  end
end
