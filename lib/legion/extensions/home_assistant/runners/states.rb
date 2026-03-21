# frozen_string_literal: true

module Legion
  module Extensions
    module HomeAssistant
      module Runners
        module States
          def get_state(entity_id:, **)
            resp = connection(**).get("/api/states/#{entity_id}")
            { state: resp.body }
          end

          def set_state(entity_id:, state:, attributes: {}, **)
            payload = { state: state, attributes: attributes }
            resp = connection(**).post("/api/states/#{entity_id}", payload)
            { state: resp.body }
          end
        end
      end
    end
  end
end
