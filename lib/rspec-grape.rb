require 'rspec/core'
require 'rack/test'

require 'rspec/grape/exceptions'
require 'rspec/grape/utils'
require 'rspec/grape/methods'

RSpec.configure do |config|
  config.include RSpec::Grape::Methods, type: :api
  config.include RSpec::Grape::Methods, :api

  after = Proc.new do
    ::Grape::Endpoint.before_each nil
  end

  config.after(:each, :api, &after)
  config.after(:each, type: :api, &after)
end
