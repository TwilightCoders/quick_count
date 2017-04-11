# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'quick_count/version'

Gem::Specification.new do |spec|
  spec.name          = 'quick_count'
  spec.version       = QuickCount::VERSION
  spec.authors       = ['Dale Stevens']
  spec.email         = ['dale@twilightcoders.net']

  spec.summary       = 'Quickly get an accurate count estimation for large tables.'
  spec.homepage      = "https://github.com/TwilightCoders/quick_count"
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '~> 2.1'

  rails_versions = ['>= 4.1', '< 6']

  spec.add_runtime_dependency 'pg', ['>= 0.12.0', '< 0.30.0']
  spec.add_runtime_dependency 'activerecord', rails_versions
  spec.add_runtime_dependency 'activesupport', rails_versions
  spec.add_runtime_dependency 'activemodel', rails_versions
  spec.add_runtime_dependency 'railties', rails_versions

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rspec', '~> 3.3'
  spec.add_development_dependency 'pry', '~> 0'
end
