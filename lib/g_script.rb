require 'pp'
require 'cgi'
require 'g_script/gs_db.rb'

module GScript
  include GScript::GsBaseModule

  class ScriptNotFound < StandardError
  end
  class ItemNotFound < StandardError
  end
  class << self
    def action(name)
      GsDb.action_class(name).new
    end
  end
end
