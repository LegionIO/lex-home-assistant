# frozen_string_literal: true

RSpec.describe Legion::Extensions::HomeAssistant::Runners::Entities do
  let(:client) { Legion::Extensions::HomeAssistant::Client.new(url: 'http://homeassistant.local:8123/api', token: 'test-token') }

  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:test_connection) do
    Faraday.new(url: 'http://homeassistant.local:8123/api') do |conn|
      conn.response :json, content_type: /\bjson$/
      conn.adapter :test, stubs
    end
  end

  before { allow(client).to receive(:connection).and_return(test_connection) }

  describe '#list_entities' do
    it 'returns a list of entities' do
      stubs.get('/api/states') do
        [200, { 'Content-Type' => 'application/json' },
         [{ 'entity_id' => 'light.living_room', 'state' => 'on' },
          { 'entity_id' => 'sensor.temperature', 'state' => '21.5' }]]
      end
      result = client.list_entities
      expect(result[:entities]).to be_a(Array)
      expect(result[:entities].first['entity_id']).to eq('light.living_room')
    end

    it 'returns an empty list when no entities exist' do
      stubs.get('/api/states') do
        [200, { 'Content-Type' => 'application/json' }, []]
      end
      result = client.list_entities
      expect(result[:entities]).to eq([])
    end
  end

  describe '#get_entity' do
    it 'returns a single entity by entity_id' do
      stubs.get('/api/states/light.living_room') do
        [200, { 'Content-Type' => 'application/json' },
         { 'entity_id' => 'light.living_room', 'state' => 'on', 'attributes' => { 'brightness' => 200 } }]
      end
      result = client.get_entity(entity_id: 'light.living_room')
      expect(result[:entity]['entity_id']).to eq('light.living_room')
      expect(result[:entity]['state']).to eq('on')
    end

    it 'returns entity attributes' do
      stubs.get('/api/states/sensor.temperature') do
        [200, { 'Content-Type' => 'application/json' },
         { 'entity_id' => 'sensor.temperature', 'state' => '21.5',
           'attributes' => { 'unit_of_measurement' => '°C' } }]
      end
      result = client.get_entity(entity_id: 'sensor.temperature')
      expect(result[:entity]['attributes']['unit_of_measurement']).to eq('°C')
    end
  end
end
