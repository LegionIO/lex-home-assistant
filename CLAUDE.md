# lex-home-assistant: Home Assistant Integration for LegionIO

**Repository Level 3 Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-other/CLAUDE.md`
- **Grandparent**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

Legion Extension that connects LegionIO to Home Assistant via the REST API. Provides runners for entity inspection, service calls, and state management.

**GitHub**: https://github.com/LegionIO/lex-home-assistant
**License**: MIT
**Version**: 0.1.0

## Architecture

```
Legion::Extensions::HomeAssistant
├── Runners/
│   ├── Entities   # list_entities, get_entity
│   ├── Services   # list_services, call_service
│   └── States     # get_state, set_state
├── Helpers/
│   └── Client     # Faraday connection (Home Assistant REST API, long-lived access token)
└── Client         # Standalone client class (includes all runners)
```

## Key Files

| Path | Purpose |
|------|---------|
| `lib/legion/extensions/home_assistant.rb` | Entry point, extension registration |
| `lib/legion/extensions/home_assistant/runners/entities.rb` | Entity list/get runners |
| `lib/legion/extensions/home_assistant/runners/services.rb` | Service discovery and invocation runners |
| `lib/legion/extensions/home_assistant/runners/states.rb` | State get/set runners |
| `lib/legion/extensions/home_assistant/helpers/client.rb` | Faraday connection builder (Bearer token auth) |
| `lib/legion/extensions/home_assistant/client.rb` | Standalone Client class |

## Authentication

Home Assistant uses long-lived access tokens. Generate one from the Home Assistant profile page under Long-Lived Access Tokens. Pass it as `token:` at client construction. The URL should include `/api` (e.g., `http://homeassistant.local:8123/api`).

## Dependencies

| Gem | Purpose |
|-----|---------|
| `faraday` (~> 2.0) | HTTP client for Home Assistant REST API |

## Development

19 specs total.

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

---

**Maintained By**: Matthew Iverson (@Esity)
