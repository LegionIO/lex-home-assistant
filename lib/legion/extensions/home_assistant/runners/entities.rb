# frozen_string_literal: true

module Legion
  module Extensions
    module HomeAssistant
      module Runners
        module Entities
          def list_entities(**)
            resp = connection(**).get('/api/states')
            { entities: resp.body }
          end

          def get_entity(entity_id:, **)
            resp = connection(**).get("/api/states/#{entity_id}")
            { entity: resp.body }
          end
        end
      end
    end
  end
end
