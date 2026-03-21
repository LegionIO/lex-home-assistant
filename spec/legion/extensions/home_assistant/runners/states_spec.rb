# frozen_string_literal: true

RSpec.describe Legion::Extensions::HomeAssistant::Runners::States do
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

  describe '#get_state' do
    it 'returns the state of an entity' do
      stubs.get('/api/states/sensor.temperature') do
        [200, { 'Content-Type' => 'application/json' },
         { 'entity_id' => 'sensor.temperature', 'state' => '21.5',
           'attributes' => { 'unit_of_measurement' => '°C' } }]
      end
      result = client.get_state(entity_id: 'sensor.temperature')
      expect(result[:state]['state']).to eq('21.5')
      expect(result[:state]['entity_id']).to eq('sensor.temperature')
    end

    it 'returns entity attributes in the state response' do
      stubs.get('/api/states/light.living_room') do
        [200, { 'Content-Type' => 'application/json' },
         { 'entity_id' => 'light.living_room', 'state' => 'on',
           'attributes' => { 'brightness' => 200, 'color_temp' => 4000 } }]
      end
      result = client.get_state(entity_id: 'light.living_room')
      expect(result[:state]['attributes']['brightness']).to eq(200)
    end
  end

  describe '#set_state' do
    it 'sets the state of an entity' do
      stubs.post('/api/states/sensor.temperature') do
        [200, { 'Content-Type' => 'application/json' },
         { 'entity_id' => 'sensor.temperature', 'state' => '22.0',
           'attributes' => { 'unit_of_measurement' => '°C' } }]
      end
      result = client.set_state(
        entity_id:  'sensor.temperature',
        state:      '22.0',
        attributes: { unit_of_measurement: '°C' }
      )
      expect(result[:state]['state']).to eq('22.0')
    end

    it 'sets state without attributes' do
      stubs.post('/api/states/input_boolean.vacation_mode') do
        [200, { 'Content-Type' => 'application/json' },
         { 'entity_id' => 'input_boolean.vacation_mode', 'state' => 'on', 'attributes' => {} }]
      end
      result = client.set_state(entity_id: 'input_boolean.vacation_mode', state: 'on')
      expect(result[:state]['state']).to eq('on')
    end

    it 'returns the updated state object' do
      stubs.post('/api/states/sensor.humidity') do
        [201, { 'Content-Type' => 'application/json' },
         { 'entity_id' => 'sensor.humidity', 'state' => '55',
           'attributes' => { 'unit_of_measurement' => '%' } }]
      end
      result = client.set_state(
        entity_id:  'sensor.humidity',
        state:      '55',
        attributes: { unit_of_measurement: '%' }
      )
      expect(result[:state]['entity_id']).to eq('sensor.humidity')
    end
  end
end
