[![Version      ](https://img.shields.io/gem/v/quick_count.svg?maxAge=2592000)](https://rubygems.org/gems/quick_count)
[![Build Status ](https://travis-ci.org/TwilightCoders/quick_count.svg)](https://travis-ci.org/TwilightCoders/quick_count)
[![Code Climate ](https://api.codeclimate.com/v1/badges/43ba3e038a91b44fba2c/maintainability)](https://codeclimate.com/github/TwilightCoders/quick_count/maintainability)
[![Test Coverage](https://codeclimate.com/github/TwilightCoders/quick_count/badges/coverage.svg)](https://codeclimate.com/github/TwilightCoders/quick_count/coverage)
[![Dependency Status](https://gemnasium.com/badges/github.com/TwilightCoders/quick_count.svg)](https://gemnasium.com/github.com/TwilightCoders/quick_count)

# QuickCount

Unfortunately, it's currently notoriously difficult and expensive to get an exact count on large tables.

Luckily, there are [some tricks](https://www.citusdata.com/blog/2016/10/12/count-performance) for quickly getting fairly accurate estimates. For example, on a table with over 450 million records, you can get a 99.82% accurate count within a fraction of of the time. See the table below for an example dataset.

**Supports:**
- PostgreSQL
  - [Multi-table Inheritance](https://github.com/TwilightCoders/active_record-mti)

| SQL | Version | Result | Accuracy | Time |
| --- | --- | --- | --- | --- |
| `SELECT count(*) FROM small_table;` | -- | `2037104` | `100.0000000%` | `4.900s` |
| `SELECT quick_count('small_table');` | `v0.0.5` | `1988857` | `97.63158877%` | `0.048s` |
| `SELECT quick_count('small_table');` | `v0.0.6` | `2036407` | `99.96578476%` | `0.050s` |
| `SELECT count(*) FROM medium_table;` | -- | `81716243` | `100.0000000%` | `257.5s` |
| `SELECT quick_count('medium_table');` | `v0.0.5` | `79352284` | `97.10711247%` | `0.049s` |
| `SELECT quick_count('medium_table');` | `v0.0.6` | `81600513` | `99.85837577%` | `0.048s` |
| `SELECT count(*) FROM large_table;` | -- | `455270802` | `100.0000000%` | `310.6s` |
| `SELECT quick_count('large_table');` | `v0.0.5` | `448170751` | `98.44047741%` | `0.047s` |
| `SELECT quick_count('large_table');` | `v0.0.6` | `454448393` | `99.81935828%` | `0.046s` |

_These metrics were pulled from real databases being used in a production environment._

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'quick_count'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install quick_count

## Usage

```ruby
# user.rb

QuickCount.install # Install with default (500000) threshold

# Change the threshold for when `quick_count` kicks in...
QuickCount.install(threshold: 500000)

class User < ActiveRecord::Base

end

User.quick_count

# Override the default threshold on a case-by-case basis.
User.quick_count(threshold: 600000)

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

Bug reports and pull requests are welcome on GitHub at https://github.com/TwilightCoders/quick_count.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
