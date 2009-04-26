module GScript
  class GsActionSpace < GsBase
    class << self
      def action(name)
        action_class(name).new
      end
      def action_class(name)
        name = name.underscore
        @@actions ||= {}
        return @@actions[name] if @@actions.key?(name)

        path = "#{RAILS_ROOT}/lib/actions/#{name}.rb"
        unless ::File.file?(path)
          raise _e("Action file '#{path}' not found.")
        end
        class_eval(::File.read(path), path)
        begin
          class_name = name.classify
          action = const_get(class_name)
        rescue
          raise _e("Action '#{class_name}' not defined.")
        end
        raise "Action Not Defined" unless action
        @@actions[name] = action
      end
    end
  end
end
