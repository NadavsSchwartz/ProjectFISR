# ProjectFIS

A simple program to locate restaurants in a desired State or ZipCode,
with an option to check restaurant's reviews and rating, and have the results sent to your preffered email.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ProjectFIS'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ProjectFIS

## Usage

run `bin/runer` for an interactive prompt.

Note:
in order to use the send-mail feature, a gmail account will be needed,
in order to look up restaurant via the us.restaurant-menu api, an api is required,
in order to make a query for google and get the location's reviews and rating, an api from serpapi is required.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/<github username>/ProjectFIS. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/<github username>/ProjectFIS/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ProjectFIS project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/<github username>/ProjectFIS/blob/master/CODE_OF_CONDUCT.md).
