[![Version      ](https://img.shields.io/gem/v/quick_count.svg?maxAge=2592000)](https://rubygems.org/gems/quick_count)
[![Build Status ](https://travis-ci.org/TwilightCoders/quick_count.svg)](https://travis-ci.org/TwilightCoders/quick_count)
[![Code Climate ](https://api.codeclimate.com/v1/badges/43ba3e038a91b44fba2c/maintainability)](https://codeclimate.com/github/TwilightCoders/quick_count/maintainability)
[![Test Coverage](https://codeclimate.com/github/TwilightCoders/quick_count/badges/coverage.svg)](https://codeclimate.com/github/TwilightCoders/quick_count/coverage)
[![Dependency Status](https://gemnasium.com/badges/github.com/TwilightCoders/quick_count.svg)](https://gemnasium.com/github.com/TwilightCoders/quick_count)

# QuickCount

Based on the answer http://stackoverflow.com/a/7945274/1454158.

It currently supports only Postgres.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'quick_count'
```

And then execute:

    $ bundle

And in a rails console:

    $ QuickCount.install

Or install it yourself as:

    $ gem install quick_count

## Usage

```ruby
# user.rb

class User < ActiveRecord::Base

end

User.quick_count
```


## Uninstallation

Remove this line to your application's Gemfile:

```ruby
gem 'quick_count'
```

And then execute:

    $ bundle

And in a rails console:

    $ QuickCount.uninstall

## License
Released under the MIT license - http://opensource.org/licenses/MIT

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/quick_count.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
