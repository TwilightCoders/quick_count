source "https://rubygems.org"

# Declare your gem's dependencies in quick_count.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.
group :development, :test do
  # Generates coverage stats of specs
  gem 'simplecov'

  # Publishes coverage to codeclimate
  gem 'codeclimate-test-reporter'

  # Gives CircleCI more perspective on our tests
  gem 'rspec_junit_formatter'

  gem 'rspec'

  gem 'database_cleaner'
end

