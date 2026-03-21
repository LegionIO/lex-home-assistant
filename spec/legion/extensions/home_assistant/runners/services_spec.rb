# frozen_string_literal: true

RSpec.describe Legion::Extensions::HomeAssistant::Runners::Services do
  let(:client) { Legion::Extensions::HomeAssistant::Client.new(url: 'http://homeassistant.local:8123/api', token: 'test-token') }

  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:test_connection) do
    Faraday.new(url: 'http://homeassistant.local:8123/api') do |conn|
      conn.request :json
      conn.response :json, content_type: /\bjson$/
      conn.adapter :test, stubs
    end
  end

  before { allow(client).to receive(:connection).and_return(test_connection) }

  describe '#list_services' do
    it 'returns a list of available services' do
      stubs.get('/api/services') do
        [200, { 'Content-Type' => 'application/json' },
         [{ 'domain' => 'light', 'services' => { 'turn_on' => {}, 'turn_off' => {} } },
          { 'domain' => 'switch', 'services' => { 'turn_on' => {}, 'turn_off' => {} } }]]
      end
      result = client.list_services
      expect(result[:services]).to be_a(Array)
      expect(result[:services].first['domain']).to eq('light')
    end
  end

  describe '#call_service' do
    it 'calls a service with entity_id' do
      stubs.post('/api/services/light/turn_on') do
        [200, { 'Content-Type' => 'application/json' },
         [{ 'entity_id' => 'light.living_room', 'state' => 'on' }]]
      end
      result = client.call_service(domain: 'light', service: 'turn_on', entity_id: 'light.living_room')
      expect(result[:result]).to be_a(Array)
    end

    it 'calls a service with additional data' do
      stubs.post('/api/services/light/turn_on') do
        [200, { 'Content-Type' => 'application/json' },
         [{ 'entity_id' => 'light.living_room', 'state' => 'on' }]]
      end
      result = client.call_service(
        domain:    'light',
        service:   'turn_on',
        entity_id: 'light.living_room',
        data:      { brightness: 200 }
      )
      expect(result[:result]).to be_a(Array)
    end

    it 'calls a service without entity_id' do
      stubs.post('/api/services/homeassistant/restart') do
        [200, { 'Content-Type' => 'application/json' }, []]
      end
      result = client.call_service(domain: 'homeassistant', service: 'restart')
      expect(result[:result]).to eq([])
    end
  end
end
