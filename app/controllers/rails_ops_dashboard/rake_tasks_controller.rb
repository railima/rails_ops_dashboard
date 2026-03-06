# frozen_string_literal: true

require 'rake'

module RailsOpsDashboard
  class RakeTasksController < BaseController
    include RailsOpsDashboard::BackgroundTaskRunner

    def index
      @rake_tasks = discover_rake_tasks
    end

    def execute
      task_name = params[:task_name]

      load_rake_tasks
      begin
        task = Rake::Task[task_name]
      rescue RuntimeError
        return redirect_to rake_tasks_path(message: "Task not found: #{task_name}", type: 'error')
      end

      unless custom_task?(task)
        return redirect_to rake_tasks_path(message: 'Cannot execute built-in tasks', type: 'error')
      end

      task_id = SecureRandom.hex(8)

      run_in_background(task_id, task_name) do
        task.reenable
        task.invoke
      end

      redirect_to rake_tasks_path(message: "Started: #{task_name}", type: 'info', task_id: task_id)
    end

    def status
      task = task_status(params[:task_id])
      render json: task || { status: 'not_found' }
    end

    private

    def load_rake_tasks
      Rake::TaskManager.record_task_metadata = true
      Rails.application.load_tasks
    end

    def custom_task?(task)
      tasks_path = RailsOpsDashboard.configuration.rake_tasks_path
      task.locations.any? { |l| l.include?(tasks_path) }
    end

    def discover_rake_tasks
      load_rake_tasks
      tasks_path = RailsOpsDashboard.configuration.rake_tasks_path
      Rake::Task.tasks
                .select { |t| t.locations.any? { |l| l.include?(tasks_path) } }
                .map { |t| { name: t.name, description: t.comment || '(no description)' } }
                .sort_by { |t| t[:name] }
    end
  end
end
