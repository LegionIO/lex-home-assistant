# frozen_string_literal: true

RSpec.describe Legion::Extensions::HomeAssistant::Client do
  subject(:client) { described_class.new(url: 'http://homeassistant.local:8123/api', token: 'test-token') }

  describe '#initialize' do
    it 'stores url in opts' do
      expect(client.opts[:url]).to eq('http://homeassistant.local:8123/api')
    end

    it 'stores token in opts' do
      expect(client.opts[:token]).to eq('test-token')
    end

    it 'uses default url when none provided' do
      c = described_class.new
      expect(c.opts[:url]).to eq('http://homeassistant.local:8123/api')
    end

    it 'token defaults to nil when not provided' do
      c = described_class.new
      expect(c.opts[:token]).to be_nil
    end
  end

  describe '#settings' do
    it 'returns a hash with options key' do
      expect(client.settings).to eq({ options: client.opts })
    end
  end

  describe '#connection' do
    it 'returns a Faraday connection' do
      expect(client.connection).to be_a(Faraday::Connection)
    end
  end
end
