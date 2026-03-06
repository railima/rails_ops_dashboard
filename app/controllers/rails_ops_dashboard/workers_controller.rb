# frozen_string_literal: true

module RailsOpsDashboard
  class WorkersController < BaseController
    before_action :check_plugin_enabled!
    before_action :check_development_only!

    PIDS = Concurrent::Map.new

    def index
      @workers = plugin_workers.map do |worker|
        worker.merge(status: worker_status(worker[:id]))
      end
    end

    def start
      worker = plugin_workers.find { |w| w[:id] == params[:id] }
      return redirect_to workers_path(message: 'Worker not found', type: 'error') unless worker

      if worker_status(params[:id]) == :running
        return redirect_to workers_path(message: "#{worker[:name]} is already running", type: 'error')
      end

      pid = Process.spawn(worker[:command])
      Process.detach(pid)
      PIDS[params[:id]] = pid

      redirect_to workers_path(message: "#{worker[:name]} started (PID: #{pid})", type: 'success')
    end

    def stop
      worker = plugin_workers.find { |w| w[:id] == params[:id] }
      return redirect_to workers_path(message: 'Worker not found', type: 'error') unless worker

      pid = PIDS.delete(params[:id])
      return redirect_to workers_path(message: 'Worker not running', type: 'error') unless pid

      begin
        Process.kill('TERM', pid)
      rescue Errno::ESRCH # rubocop:disable Lint/SuppressedException
      end

      redirect_to workers_path(message: "Stop signal sent to #{worker[:name]}", type: 'success')
    end

    private

    def plugin_workers
      RailsOpsDashboard.configuration.plugins.dig(:workers, :workers) || []
    end

    def check_plugin_enabled!
      return if RailsOpsDashboard.configuration.plugins.key?(:workers)

      redirect_to root_path(message: 'Workers plugin is not enabled', type: 'error')
    end

    def check_development_only!
      return unless RailsOpsDashboard.configuration.plugins.dig(:workers, :development_only)
      return if Rails.env.development?

      redirect_to root_path(message: 'Workers management is only available in development', type: 'error')
    end

    def worker_status(id)
      pid = PIDS[id]
      return :stopped unless pid

      Process.kill(0, pid)
      :running
    rescue Errno::ESRCH
      PIDS.delete(id)
      :stopped
    end
  end
end
