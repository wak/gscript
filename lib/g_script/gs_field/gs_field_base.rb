module GScript
  module GsField
    class GsFieldBase < GsBase
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::FormTagHelper

      attr_reader :value, :name

      def initialize(name, type, option={}, &verify)
        @name = name
        @fieldname = "gs_#{name}"
        @type = type
        @option = option
        @verify = verify
        @value = nil
      end
      def ==(name)
        @fieldname == name.to_s
      end
      def generate; end
      def valid?
        return false unless @value unless @option.key?(:nil)
        return false if @verify && !@verify.call(@value)
        return true
      end
      def field_to_gs(gs, to, obj)
        case to
        when :symbol
          obj.to_sym
        when :file
          GFile.new(obj)
        when :actor
          gs.actor(obj) rescue nil
        when :item
          if /\A([[:alpha:]]+).([[:alpha:]]+)\z/ =~ obj
            login, iname = $1, $2
            return gs.actor(login).item(iname) rescue nil
          end
        when :int
          Integer(obj) rescue nil
        end
      end
      def gs_to_field(obj)
        # return [value, name]
        case obj
        when GsActor
          [obj.login, obj.login]
        when GsItem
          ["#{obj.actor.login}.#{obj.iname}", obj.iname]
        else
          [obj.to_s, obj.to_s]
        end
      end
      def set_value(gs, value)
        @value = field_to_gs(gs, @type, value)
        return !@value.nil?
      end

      protected
      def h(str)
        CGI.escapeHTML(str)
      end
      def get_options(*opts)
        opt = {}
        opts.each {|o|
          opt[o] = @option[o] if @option.key?(o)
        }
        return opt
      end
    end
  end
end
