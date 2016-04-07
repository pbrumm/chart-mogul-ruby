# ChartMogul

This gem is designed to streamline interaction with the [ChartMogul](https://dev.chartmogul.com) API. The initial focus has been on support for the [Import API](link!!).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'chart_mogul'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chart_mogul

## Usage

Credentials are provided in the Account / API area of the ChartMogul application and comprise an `account_token` and `secret_key`.

This can be passed in when insantiating a `ChartMogul::Client` instance, eg:

```ruby
client = ChartMogul::Client.new(account_token: 'token value', secret_key: 'secret value')
```

If not passed to the constructor the values returned by the `CHART_MOGUL_ACCOUNT_TOKEN` and `CHART_MOGUL_SECRET_KEY` environment variables are used.

Methods for access the API are exposed on the `client`.

### Reading data

Reading methods, `list_` prefix,  are either presented as simple methods that page through all responses from the API and present a fully populated Array of typed objects.

```ruby
client.list_customers  # => [ Import::Customer, Import::Customer ]
```

and as an iterative version, with an `_each` suffix, that expects a block. Useful for those situations where you're dealing with a lot of records and don't want them necessarily all in memory. This again handles the paging transparently.

The block is yielded to with a typed object.

```ruby
client.list_customers_each do |customer|
  # do something with the Import::Customer here
end
```

### Importing data

Data records are imported by passing a Hash of attributes to a `create_` prefixed method.

```ruby
client.create_plan({
  data_source_uuid: "ds_2323232",
  name: "Top Plan",
  interval_count: 1,
  interval_unit: :month
})
```

Dates and times are expected as `Time` objects. The gem handles the formatting required by the ChartMogul API.

Where possible pre request validation is also handled by the gem. `ArgumentErrors` with a description of the variable are raised in the event that pre submit validation fails.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/adambird/chart_mogul. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

