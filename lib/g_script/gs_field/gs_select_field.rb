module GScript
  module GsField
    class GsSelectField < GsFieldBase
      def initialize(name, type, option={}, &verify)
        super(name, type, option, &verify)
        @option[:list] ||= []
      end
      def generate
        desc = @option[:desc]
        desc = desc ? "#{h(desc)}: " : ''
        list = @option[:list]
        option_tags = list.map {|actor|
          value, name = gs_to_field(actor)
          sprintf("<option value=\"%s\">%s</option>", value, h(name))
        }
        option_tags.unshift("<option>&nbsp;</option>")
        return desc + select_tag(@fieldname, option_tags.join)
      end
      def valid?
        return false unless @value
        return false unless @option[:list].member?(@value)
        return super
      end
    end
  end
end
