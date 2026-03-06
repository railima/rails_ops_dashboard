# frozen_string_literal: true

module RailsOpsDashboard
  class Configuration
    attr_accessor :username, :password, :blocked_environments,
                  :seeds_path, :seeds_base_class, :seeds_executor,
                  :rake_tasks_path

    attr_reader :plugins

    def initialize
      @username = 'admin'
      @password = 'password'
      @blocked_environments = %w[production]
      @seeds_path = 'app/services/database_update'
      @seeds_base_class = 'DatabaseUpdate'
      @seeds_executor = ->(klass) { klass.new.call }
      @rake_tasks_path = 'lib/tasks'
      @plugins = {}
    end

    def plugin(name, **options)
      @plugins[name] = options
    end
  end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset_configuration!
      @configuration = Configuration.new
    end
  end
end
