require 'spec_helper'

describe RSpec::Grape::Methods, include_methods: true do
  before do
    allow(RSpec::Grape::Utils)
      .to receive(:find_endpoint_description).and_return('POST /api/v1/test')
  end

  describe '#app' do
    subject { app }
    before { expect(self).to receive(:described_class).and_call_original.twice }    
    it { is_expected.to eq(described_class) }
  end

  describe '#api_url' do
    subject { api_url }

    it { is_expected.to eq('/api/v1/test') }
  end

  describe '#api_method' do
    subject { api_method }

    it { is_expected.to eq(:post) }
    it { is_expected.to be_kind_of(Symbol) }
  end

  describe '#call_api' do
    it 'calls appropriate rack/test method and returns its result' do
      expect(self).to receive(:send).with(api_method, api_url, {}).and_return(:result)
      expect(call_api).to eq(:result)
    end

    context 'when api_params is defined' do
      let(:api_params) { { foo: :bar } }

      it 'uses api_params' do
        expect(self).to receive(:send).with(api_method, api_url, api_params)        
        call_api
      end

      context 'when params are explicitly passed to call_api' do
        it 'uses api_params instead' do
          params = { override: true }
          expect(self).to receive(:send).with(api_method, api_url, params)
          
          call_api(params)
        end
      end
    end

    context 'when params are explicitly passed to api_call' do
      it 'uses passed params' do
        params = { test: true }
        expect(self).to receive(:send).with(api_method, api_url, params)
        
        call_api(params)
      end
    end
  end

  describe '#expect_endpoint_to' do
    it 'calls Grape::Endoint.before_each' do
      expect(Grape::Endpoint).to receive(:before_each)

      expect_endpoint_to be_nil
    end
  end

  describe '#expect_endpoint_not_to' do
    it 'calls Grape::Endoint.before_each' do
      expect(Grape::Endpoint).to receive(:before_each)

      expect_endpoint_not_to be_nil
    end
  end
end
