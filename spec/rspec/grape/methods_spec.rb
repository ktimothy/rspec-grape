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

      context 'with parameterized url' do
        it 'uses parameterized_url' do
          allow(self).to receive(:api_url).and_return('/url/with/:param')
          allow(self).to receive(:api_method).and_return(:get)

          expect(self).to receive(:parameterized_api_url).and_call_original
          expect(self).to receive(:send).with(anything, '/url/with/defined_value', anything)
          
          call_api(param: 'defined_value')
        end
      end

      context 'with not parameterized url' do
        it 'uses api_url url' do
          allow(self).to receive(:api_url).and_return('/simple/url')
          allow(self).to receive(:api_method).and_return(:get)

          expect(self).not_to receive(:parameterized_api_url)
          expect(self).to receive(:send).with(anything, '/simple/url', anything)
          
          call_api
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

  describe '#parameterized_api_url' do
    context 'when url is not parameterized' do
      before { allow(self).to receive(:api_url).and_return('/not/parameterized') }
      subject { parameterized_api_url }

      it 'raises exception' do
        expect { subject }.to raise_exception(RSpec::Grape::UrlIsNotParameterized)
      end
    end

    context 'when url is parameterized' do
      before { allow(self).to receive(:api_url).and_return('/url/with/:param') }
      subject { parameterized_api_url }

      context 'when parameter is not set' do
        it 'raises exception' do
          expect { subject }.to raise_exception(RSpec::Grape::UrlParameterNotSet)
        end
      end

      context 'when parameter is defined' do
        let(:api_params) { { param: 'defined_value' } }

        it { is_expected.to eq("/url/with/#{api_params[:param]}") }
      end
    end
  end
end
