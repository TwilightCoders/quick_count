[![Version      ](https://img.shields.io/gem/v/quick_count.svg)](https://rubygems.org/gems/quick_count)
[![CI Status   ](https://github.com/TwilightCoders/quick_count/workflows/CI/badge.svg)](https://github.com/TwilightCoders/quick_count/actions)
[![Code Quality](https://img.shields.io/badge/code%20quality-qlty-blue)](https://github.com/TwilightCoders/quick_count)

# QuickCount

Unfortunately, it's currently notoriously difficult and expensive to get an exact count on large tables.

Luckily, there are [some tricks](https://www.citusdata.com/blog/2016/10/12/count-performance) for quickly getting fairly accurate estimates. For example, on a table with over 450 million records, you can get a 99.82% accurate count within a fraction of of the time. See the table below for an example dataset.

**Supports:**
- PostgreSQL
  - [Multi-table Inheritance](https://github.com/TwilightCoders/active_record-mti)
- MySQL

| SQL | Result | Accuracy | Time |
| --- | --- | --- | --- |
| `SELECT count(*) FROM small_table;` | `2037104` | `100.0000000%` | `4.900s` |
| `Post.quick_count` | `2036407` | `99.96578476%` | `0.050s` |
| `SELECT count(*) FROM medium_table;` | `81716243` | `100.0000000%` | `257.5s` |
| `Post.quick_count` | `81600513` | `99.85837577%` | `0.048s` |
| `SELECT count(*) FROM large_table;` | `455270802` | `100.0000000%` | `310.6s` |
| `Post.quick_count` | `454448393` | `99.81935828%` | `0.046s` |

_These metrics were pulled from real databases being used in a production environment._

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'quick_count'
```

And then execute:

    $ bundle

That's it. QuickCount automatically integrates with ActiveRecord via a Railtie — no setup step required.

## Usage

```ruby
# Fast estimated count for large tables
User.quick_count

# Override the default threshold (500,000) on a case-by-case basis
User.quick_count(threshold: 1_000_000)

# Estimate row count for an arbitrary query
User.where(active: true).count_estimate
```

If the estimated count is below the threshold, `quick_count` falls back to an exact `SELECT COUNT(*)`. For tables above the threshold, it returns the estimate directly.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/TwilightCoders/quick_count.
