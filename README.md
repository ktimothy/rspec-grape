# Rspec::Grape

This gem is a set of spec helpers, that will help to test [Grape](https://github.com/ruby-grape/grape) APIs easily. The usual approach to test apis, as [official documentation shows](https://github.com/ruby-grape/grape#rspec), is:

```
context 'GET /api/v1/test' do
  it 'returns 200' do
    get '/api/v1/test'
    expect(last_response.status).to eq(200)
  end
end
```

Here you describe context as `GET /api/v1/test`, then you have to repeat url and method in example: `get '/api/v1/test'`. But what if you don't have to?


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec-grape'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec-grape

## Usage

### Conventions

Gem's behaviour is based on some conventions:
* `described_class` should point to your API class
* examples should be grouped by endpoints
* group of endpoint specs shoud be described as 'HTTP_METHOD /api/path'

### Basic usage

This gem provides the `call_api` helper method. It automatically reads endpoint url and method from context description, allowing you to avoid duplication and write a shorter spec:

```
context 'GET /api/v1/test' do
  it 'returns 200' do
    expect(call_api.status).to eq(200)
  end
end
```

### Passing request params

Params can be either passed to `call_api` method:

```
call_api({foo: :bar})
```

or set via `let`:

```
let(:api_params) { { foo: :bar } }
```

Note, that params, explicitly passed to `call_api`, have precendence over thoose set in `api_params`.


### Additional spec helpers

It is also possible to use two methods in your specs: `api_url` and `api_method`. The former returns url from spec description, while the latter returns http method.

You can always use them, as `call_api` methods does:

```
send(api_method, api_url)
```

## TODO

* Support urls with params: `/api/test/:id`
* Provide `api_helpers` for easier helpers stubbing [see](https://github.com/ruby-grape/grape#stubbing-helpers)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ktimothy/rspec-grape.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

