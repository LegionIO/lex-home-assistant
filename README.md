# lex-home-assistant

LegionIO extension for Home Assistant integration via the Home Assistant REST API.

## Installation

Add to your Gemfile:

```ruby
gem 'lex-home-assistant'
```

## Standalone Usage

```ruby
require 'legion/extensions/home_assistant'

client = Legion::Extensions::HomeAssistant::Client.new(
  url:   'http://homeassistant.local:8123/api',
  token: 'your-long-lived-access-token'
)

# Entities
client.list_entities
client.get_entity(entity_id: 'light.living_room')

# Services
client.list_services
client.call_service(domain: 'light', service: 'turn_on', entity_id: 'light.living_room')
client.call_service(domain: 'light', service: 'turn_on', entity_id: 'light.living_room', data: { brightness: 200 })

# States
client.get_state(entity_id: 'sensor.temperature')
client.set_state(entity_id: 'sensor.temperature', state: '21.5', attributes: { unit_of_measurement: '°C' })
```

## Authentication

Home Assistant requires a long-lived access token passed as a Bearer token in the `Authorization` header. Generate a token from your Home Assistant profile page under Long-Lived Access Tokens.

## License

MIT
