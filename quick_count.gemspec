require_relative 'lib/quick_count/version'

Gem::Specification.new do |spec|
  spec.name          = 'quick_count'
  spec.version       = QuickCount::VERSION
  spec.authors       = ['Dale Stevens']
  spec.email         = ['dale@twilightcoders.net']

  spec.summary       = 'Quickly get an accurate count estimation for large tables.'
  spec.description   = 'Installs two database functions, `quick_count` and `count_estimate` for getting count estimations on large tables'
  spec.homepage      = "https://github.com/TwilightCoders/quick_count"
  spec.license       = 'MIT'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.files         = Dir['CHANGELOG.md', 'README.md', 'LICENSE', 'lib/**/*']
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib', 'spec']

  rails_versions = ['>= 4', '< 6.1']
  spec.required_ruby_version = '>= 2.0'

  spec.add_runtime_dependency 'pg'
  spec.add_runtime_dependency 'activerecord', rails_versions
  spec.add_runtime_dependency 'railties', rails_versions

  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'combustion'

end
