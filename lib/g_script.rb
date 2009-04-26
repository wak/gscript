require 'pp'
require 'cgi'

module GScript
  include GScript::GsBaseModule

  class ScriptNotFound < StandardError
  end
  class ItemNotFound < StandardError
  end
end
