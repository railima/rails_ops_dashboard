# Rails Ops Dashboard

A lightweight operations dashboard for Rails applications. Run seeds, execute rake tasks, inspect environment variables, and manage background workers, all from a single web interface protected by HTTP Basic Auth.

## Why this gem?

This gem was born from a real pain point. In our team, running a simple rake task or seed script on staging required a full infrastructure odyssey: connect to the VPN, authenticate via AWS SSO, generate an EKS token with `aws eks get-token`, open the Kubernetes dashboard, find the right environment, locate the Rails pod, open a terminal session inside the container, and only then run the actual command. Six or seven steps just to execute `rake db:seed`.

We built an internal ops dashboard to skip all of that. Instead of tunneling through layers of infrastructure, any developer on the team could open a browser, authenticate with a simple password, and run the operation directly. After using it for a while, we realized this was a generic enough problem that other teams probably deal with the same friction, so we extracted it into this gem.

Most Rails dashboard gems focus on admin CRUD for models (Avo, Administrate, RailsAdmin, Motor Admin). None of them provide a simple developer operations panel for the tasks you actually do during development and staging: running seed scripts, checking environment variables, or kicking off rake tasks. This gem fills that gap.

## Should I use this gem?

This gem is built for **development and staging environments**. It is blocked in production by default, and the in-memory task tracking does not persist across server restarts.

**Good fit if you:**
- Run seed scripts regularly during development or staging
- Want a quick way to execute and monitor rake tasks
- Need to inspect environment variables without a terminal
- Want to start/stop background workers (Sidekiq, etc.) from a UI during development

**Not a good fit if you:**
- Need a production admin dashboard for CRUD operations on models
- Need persistent job monitoring (use Sidekiq Web or GoodJob Dashboard instead)
- Need role-based access control beyond a single username/password

## Installation

Add to your Gemfile:

```ruby
gem 'rails_ops_dashboard'
```

Run the install generator:

```bash
bundle install
rails generate rails_ops_dashboard:install
```

This creates an initializer at `config/initializers/rails_ops_dashboard.rb` and mounts the engine at `/ops` in your routes.

Start your server and visit `http://localhost:3000/ops`.

## Configuration

```ruby
# config/initializers/rails_ops_dashboard.rb

RailsOpsDashboard.configure do |config|
  # HTTP Basic Auth credentials
  config.username = ENV.fetch('OPS_DASHBOARD_USERNAME', 'admin')
  config.password = ENV.fetch('OPS_DASHBOARD_PASSWORD', 'password')

  # Environments where the dashboard returns 404
  config.blocked_environments = %w[production]

  # Seeds: directory to scan for seed classes
  config.seeds_path = 'app/services/database_update'

  # Seeds: namespace prefix for discovered classes
  config.seeds_base_class = 'DatabaseUpdate'

  # Seeds: how to execute a seed class (receives the class constant)
  config.seeds_executor = ->(klass) { klass.new.call }

  # Rake tasks: only tasks defined in this path are shown
  config.rake_tasks_path = 'lib/tasks'

  # Workers plugin (disabled by default)
  # config.plugin :workers,
  #   development_only: true,
  #   workers: [
  #     { id: 'sidekiq', name: 'Sidekiq', command: 'bundle exec sidekiq' },
  #     { id: 'webpacker', name: 'Webpacker', command: 'bin/webpack-dev-server' }
  #   ]
end
```

## Core Modules

### Seeds

Discovers seed classes from a configurable directory. Each Ruby file in `seeds_path` is mapped to a class under `seeds_base_class`. For example, `app/services/database_update/add_test_data.rb` maps to `DatabaseUpdate::AddTestData`.

Seeds run in background threads with real-time status polling. The dashboard validates that each class belongs to the configured namespace and has a matching file before execution.

### Rake Tasks

Lists rake tasks defined in your configured `rake_tasks_path` directory. Built-in Rails tasks (like `db:migrate`) are filtered out, so you only see your project's custom tasks. Tasks run in background threads with status tracking.

### Environment

Displays a searchable table of all environment variables, plus metadata cards showing the Rails environment, hostname, Ruby version, Rails version, and process ID.

In many teams, the DevOps team is responsible for creating and updating environment variables across all environments, while developers only have read access. Verifying whether a variable was actually set or changed meant going through the entire VPN, SSO, Kubernetes flow described above. In practice, we would ask DevOps to update a value, they would sometimes forget or delay it, and we had no quick way to confirm without tunneling into the pod. This screen exists so any developer can open the dashboard and immediately see the current state of all environment variables, without bothering anyone or navigating infrastructure tooling.

## Workers Plugin

The workers plugin lets you start and stop system processes from the dashboard. It is disabled by default and must be explicitly enabled in the configuration.

```ruby
RailsOpsDashboard.configure do |config|
  config.plugin :workers,
    development_only: true,
    workers: [
      { id: 'sidekiq', name: 'Sidekiq', command: 'bundle exec sidekiq' },
      { id: 'redis', name: 'Redis', command: 'redis-server' }
    ]
end
```

When `development_only` is `true` (the default), the workers page is only accessible in the development environment.

Each worker definition requires:
- `id`: unique identifier for the worker
- `name`: display name in the UI
- `command`: shell command to start the process

## View Customization

To override the default views, copy them to your application:

```bash
rails generate rails_ops_dashboard:views
```

This copies all views to `app/views/rails_ops_dashboard/` in your app, where they take precedence over the gem's built-in views. The layout uses Tailwind CSS via CDN and vanilla JavaScript, so there are no asset pipeline dependencies.

## Security

The dashboard uses HTTP Basic Auth with timing-attack-safe credential comparison via `ActiveSupport::SecurityUtils.secure_compare`. CSRF protection is skipped since the dashboard uses stateless authentication.

In blocked environments (production by default), the dashboard returns a 404 response, which avoids revealing the existence of the endpoint.

Always configure credentials via environment variables in any shared environment.

## Compatibility

- Ruby 3.1+
- Rails 7.0, 7.1, 7.2, 8.0

The only runtime dependency beyond Rails is `concurrent-ruby` (for thread-safe in-memory task tracking).

## Development

After checking out the repo:

```bash
bundle install
bundle exec rspec
```

The test suite uses a dummy Rails app in `spec/dummy/` for integration testing.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/railima/rails_ops_dashboard.

1. Fork the repository
2. Create your feature branch (`git checkout -b my-feature`)
3. Write tests for your changes
4. Make sure all tests pass (`bundle exec rspec`)
5. Commit your changes
6. Push to your branch and open a pull request

## License

This gem is available as open source under the terms of the [MIT License](LICENSE).
