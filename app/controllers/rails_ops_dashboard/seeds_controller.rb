# frozen_string_literal: true

module RailsOpsDashboard
  class SeedsController < BaseController
    include RailsOpsDashboard::BackgroundTaskRunner

    def index
      @seeds = discover_seeds
    end

    def execute
      config = RailsOpsDashboard.configuration
      class_name = params[:class_name]

      unless class_name&.start_with?("#{config.seeds_base_class}::") && valid_seed?(class_name)
        return redirect_to seeds_path(message: 'Invalid seed class', type: 'error')
      end

      task_id = SecureRandom.hex(8)
      klass = class_name.constantize

      run_in_background(task_id, class_name) do
        config.seeds_executor.call(klass)
      end

      redirect_to seeds_path(message: "Started: #{class_name}", type: 'info', task_id: task_id)
    rescue NameError, LoadError
      redirect_to seeds_path(message: "Class not found: #{class_name}", type: 'error')
    end

    def status
      task = task_status(params[:task_id])
      render json: task || { status: 'not_found' }
    end

    private

    def discover_seeds
      config = RailsOpsDashboard.configuration
      Dir.glob(Rails.root.join(config.seeds_path, '*.rb')).map do |file|
        basename = File.basename(file, '.rb')
        { name: "#{config.seeds_base_class}::#{basename.camelize}", filename: basename }
      end.sort_by { |s| s[:name] }
    end

    def valid_seed?(class_name)
      config = RailsOpsDashboard.configuration
      filename = class_name.sub("#{config.seeds_base_class}::", '').underscore
      File.exist?(Rails.root.join(config.seeds_path, "#{filename}.rb"))
    end
  end
end
