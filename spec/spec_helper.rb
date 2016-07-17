$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rspec-grape'
require 'grape'

module SpecHelpers
  def is_expected_to_raise(*args)
    expect { subject }.to raise_exception(*args)
  end
end

RSpec.configure do |config|
  config.include SpecHelpers
  config.include RSpec::Grape::Methods, include_methods: true
end
