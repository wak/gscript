require 'pp'
require 'cgi'

# Please run Rails with shared-nothing architecture.

module GScript
  include GScript::GsBaseModule

  class ScriptNotFound < StandardError
  end
  class ItemNotFound < StandardError
  end

  def self.current_engine=(engine)
    @@current_engine = engine
  end
  def self.current_engine
    @@current_engine
  end
end
