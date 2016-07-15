require 'grape'

class TestAPI < Grape::API
  format :json

  class << self
    attr_accessor :api_was_called
  end
  
  get :test_api_was_called do
    TestAPI.api_was_called = true
  end

  params do
    requires :param
  end
  get :test_params do
    { result: params[:param] }
  end

  params do
    requires :param
  end
  get :test_api_params do
    { result: params[:param] }
  end
end
