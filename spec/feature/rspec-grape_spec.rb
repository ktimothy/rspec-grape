require 'spec_helper'
require 'support/test_api'

describe TestAPI, :api do
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

  describe 'GET /test_helper_invocation' do
    describe '#expect_endpoint_to' do
      it 'calls helper method' do
        result = { helper_stubbed: true }
        expect_endpoint_to receive(:help_me).and_return(result)

        call_api
        expect(last_response.body).to eq(result.to_json)
      end
    end

    describe '#expect_endpoint_not_to' do
      it 'does not call helper method' do
        expect_endpoint_not_to receive(:dont_help_me)

        call_api
      end
    end
  end

  describe 'GET /params/:param/:id' do
    context 'when parameter is not set' do
      it 'raises exception' do
        expect {
          call_api
          }.to raise_exception(RSpec::Grape::UrlParameterNotSet)
      end
    end

    context 'when parameter values set' do
      it 'assigns all values' do
        params = { param: 'defined', id: '129' }
        call_api(params)
        
        expect(last_response.body).to eq(params.to_json)
      end
    end
  end
end
