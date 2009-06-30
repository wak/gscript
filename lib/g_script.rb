require 'pp'
require 'cgi'

# Please run Rails with shared-nothing architecture.

module GScript
  include GScript::GsBaseModule

  class ScriptNotFound < StandardError
  end
  class ItemNotFound < StandardError
  end

  class << self
    def current_engine=(engine)
      @@current_engine = engine
    end
    def current_engine
      @@current_engine
    end
    def action(action_name)
      GScript::GsActionSpace.action(action_name)
    end
    def action_class(action_name)
      GScript::GsActionSpace.action_class(action_name)
    end
  end
end
