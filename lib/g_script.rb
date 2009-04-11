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
        action.actors = load_action(name)._gs_allowed_actors
        action.save!
      }
    end
    def action(name)
      load_action(name).new
    end
    def load_action(name)
      @@actions ||= {}
      return @@actions[name] if @@actions.key?(name)

      path = "#{RAILS_ROOT}/lib/actions/#{name.underscore}.rb"
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

#p GScript::Engine.new._execute_file(:test, :first)
