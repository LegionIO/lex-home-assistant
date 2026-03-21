# frozen_string_literal: true

require_relative 'helpers/client'
require_relative 'runners/entities'
require_relative 'runners/services'
require_relative 'runners/states'

module Legion
  module Extensions
    module HomeAssistant
      class Client
        include Helpers::Client
        include Runners::Entities
        include Runners::Services
        include Runners::States

        attr_reader :opts

        def initialize(url: 'http://homeassistant.local:8123/api', token: nil, **extra)
          @opts = { url: url, token: token, **extra }
        end

        def settings
          { options: @opts }
        end

        def connection(**override)
          super(**@opts, **override)
        end
      end
    end
  end
end
