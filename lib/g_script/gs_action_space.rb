module GScript
  class GsActionSpace < GsBase
    class << self
      def action(name)
        action_class(name).new
      end
      def action_class(name)
        name = name.to_s.underscore
        @@actions ||= {}
        return @@actions[name] if @@actions.key?(name)

        path = "#{RAILS_ROOT}/lib/actions/#{name}.rb"
        unless ::File.file?(path)
					raise ActionNotFound, _e("Action file '#{path}' not found.")
        end
        class_eval(::File.read(path), path)
        _d "Load action file `#{path}'"
        begin
          class_name = name.classify
          action = const_get(class_name)
        rescue
					raise ActionNotFound, _e("Action '#{class_name}' not defined.")
        end
        @@actions[name] = action
      end
    end
  end
end
