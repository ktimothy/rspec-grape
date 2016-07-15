require 'spec_helper'
require 'support/test_api'

describe 'Including test methods' do
  context 'when using symbol metadata', :api do
    it 'includes \'call_api\' method' do
      expect(self.respond_to?(:call_api)).to be_truthy
    end
  end

  context 'when using hash metadata', type: :api do
    it 'includes \'call_api\' method' do
      expect(self.respond_to?(:call_api)).to be_truthy
    end
  end

  context 'with no metadata' do
    it 'does not include \'call_api\' method' do
      expect(self.respond_to?(:call_api)).to be_falsy
    end
  end
end
