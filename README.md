# Rspec::Grape [![Build Status](https://travis-ci.org/ktimothy/rspec-grape.svg?branch=master)](https://travis-ci.org/ktimothy/rspec-grape) [![Gem Version](https://badge.fury.io/rb/rspec-grape.svg)](https://badge.fury.io/rb/rspec-grape)

This gem is a set of spec helpers, that will help to test [Grape](https://github.com/ruby-grape/grape) APIs easily. The usual approach to test apis, as [official documentation shows](https://github.com/ruby-grape/grape#rspec), is:

```ruby
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

In order to have helpers available in examples, you need to add `type: :api` metadata:
```ruby
describe MyAPI, type: :api do
```
Or use a symbol:
```ruby
describe MyAPI, :api do
```

### Basic usage

This gem provides the `call_api` helper method. It automatically reads endpoint url and method from context description, allowing you to avoid duplication and write a shorter spec:

```ruby
context 'GET /api/v1/test' do
  it 'returns 200' do
    expect(call_api.status).to eq(200)
  end
end
```

### Passing request params

Params can be passed to `call_api` method:

```ruby
call_api({foo: :bar})
```

### Stubbing API helpers

rspec-grape provides two methods to stub API helpers: `expect_endpoint_to` and `expect_endpoint_not_to`. You can easily write:

```ruby
expect_endpoint_to receive(:help_me)
expect_endpoint_not_to receive(:dont_help)
```

Note that under the hood those methods use `Grape::Endpoint.before_each`, as suggested by [documentation](https://github.com/ruby-grape/grape#stubbing-helpers). Thanks to [Jon Rowe](https://github.com/JonRowe) for the idea.

### Inline parameters

When you define some parameters in url like
```ruby
get '/url/with/:param'
```
you can use `parameterized_api_url` helper to generate full url. Pass parameters as hash. The result will be url with parameter names substituted with actual values:
```ruby
parameterized_api_url(param: 'defined') # '/url/with/defined'
```

If some parameters are not set, method will raise `RSpec::Grape::UrlNotSetException`.
Note that `call_api` helper will use parameterized_url to generate url to be called.

### Nested descriptions

You may need to define nested descriptions of endpoint when you are using inline url parameters:
```ruby
describe 'GET /inline/:param' do
  describe 'GET /inline/false' do
    ...
  end

  describe 'GET /inline/true' do
    ...
  end
end
```

In this case `api_url` will point to inner description, `/inline/false` and `/inline/true` consequently. If you set all inline parameters in description, there is no need to pass parameters to `call_api`.

### Additional spec helpers

It is also possible to use two methods in your specs: `api_url` and `api_method`. The former returns url from spec description, while the latter returns http method.

You can always use them, as `call_api` methods does:

```ruby
send(api_method, api_url)
```

Note that you do not need to `include Rack::Test::Methods` as they are already included by gem.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ktimothy/rspec-grape.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

