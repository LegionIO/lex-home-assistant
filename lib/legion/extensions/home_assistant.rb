# frozen_string_literal: true

require 'legion/extensions/home_assistant/version'
require 'legion/extensions/home_assistant/helpers/client'
require 'legion/extensions/home_assistant/runners/entities'
require 'legion/extensions/home_assistant/runners/services'
require 'legion/extensions/home_assistant/runners/states'
require 'legion/extensions/home_assistant/client'

module Legion
  module Extensions
    module HomeAssistant
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end
