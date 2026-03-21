# frozen_string_literal: true

require 'faraday'

module Legion
  module Extensions
    module HomeAssistant
      module Helpers
        module Client
          def connection(url: 'http://homeassistant.local:8123/api', token: nil, **_opts)
            Faraday.new(url: url) do |conn|
              conn.request :json
              conn.response :json, content_type: /\bjson$/
              conn.headers['Authorization'] = "Bearer #{token}" if token
              conn.adapter Faraday.default_adapter
            end
          end
        end
      end
    end
  end
end
