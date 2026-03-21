# frozen_string_literal: true

module Legion
  module Extensions
    module HomeAssistant
      module Runners
        module Services
          def list_services(**)
            resp = connection(**).get('/api/services')
            { services: resp.body }
          end

          def call_service(domain:, service:, entity_id: nil, data: {}, **)
            payload = data.dup
            payload[:entity_id] = entity_id if entity_id
            resp = connection(**).post("/api/services/#{domain}/#{service}", payload)
            { result: resp.body }
          end
        end
      end
    end
  end
end
