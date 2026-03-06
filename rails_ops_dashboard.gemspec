# frozen_string_literal: true

require_relative 'lib/rails_ops_dashboard/version'

Gem::Specification.new do |spec|
  spec.name          = 'rails_ops_dashboard'
  spec.version       = RailsOpsDashboard::VERSION
  spec.authors       = ['Rai Lima']
  spec.email         = ['railima@users.noreply.github.com']

  spec.summary       = 'A developer operations dashboard for Rails applications'
  spec.description   = 'Lightweight ops dashboard for Rails: run seeds, execute rake tasks, inspect environment variables, and manage workers. All behind HTTP Basic Auth, blocked in production by default.'
  spec.homepage      = 'https://github.com/railima/rails_ops_dashboard'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.1.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir['{app,config,lib}/**/*', 'LICENSE', 'README.md', 'CHANGELOG.md']
  spec.require_paths = ['lib']

  spec.add_dependency 'concurrent-ruby', '~> 1.0'
  spec.add_dependency 'railties', '>= 7.0'
end
