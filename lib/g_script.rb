require 'pp'
require 'cgi'

module GScript
  include GScript::GsBaseModule

  class ScriptNotFound < StandardError
  end
  class ItemNotFound < StandardError
  end
  class << self
    def init_actions
      Action.destroy_all
      Dir.glob("#{RAILS_ROOT}/lib/actions/*.rb").map {|path|
        action = Action.new
        name = path.slice(/\A.*?([a-z_]+)\.rb\z/, 1)
        action.iname = name
        action.actors = action_class(name)._gs_allowed_actors
        action.save!
      }
    end
    def action(name)
      action_class(name).new
    end
    def action_class(name)
      name = name.underscore
      @@actions ||= {}
      return @@actions[name] if @@actions.key?(name)

      path = "#{RAILS_ROOT}/lib/actions/#{name}.rb"
      unless File.file?(path)
        raise _e("Action file '#{path}' not found.")
      end
      GScript::GsActionSpace.class_eval(File.read(path), path)
      begin
        class_name = name.classify
        action = GScript::GsActionSpace.const_get(class_name)
      rescue
        raise _e("Action '#{class_name}' not defined.")
      end
      raise "Action Not Defined" unless action
      @@actions[name] = action
    end
  end
end
