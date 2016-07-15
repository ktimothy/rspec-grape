require 'spec_helper'
require 'support/test_api'

describe TestAPI, type: :api do
  describe 'GET /test_api_was_called' do
    it 'calls api' do
      call_api

      expect(TestAPI.api_was_called).to be_truthy
    end
  end

  let(:params) { { param: '123456' } }
  let(:result) { { result: '123456' }.to_json }

  describe 'GET /test_params' do
    it 'handles passed params' do
      call_api(params)

      expect(last_response.body).to eq(result)
    end
  end

  describe 'GET /test_api_params' do
    let(:api_params) { params }

    it 'uses api_params' do
      call_api

      expect(last_response.body).to eq(result)
    end
  end

  context 'when no valid endpoint description' do
    it 'raises exception' do
      expect {
        call_api
      }.to raise_exception(RSpec::Grape::NoEndpointDescription)
    end
  end
end
