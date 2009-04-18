module GScript
  module GsField
    class GsSelectField < GsFieldBase
      def initialize(name, type, option={}, &verify)
        super(name, type, option, &verify)
        @options[:list] ||= []
      end
      def generate
        desc = option(:desc)
        desc = desc ? "#{h(desc)}: " : ''
        elements = option(:list)
        is_selected = false
        selected = (@value ? @value :
                     (@value == false) ? @value :
                       option(:selected))
        option_tags = elements.map {|e|
          value, name = gs_to_field(e)
          format =
            if !is_selected && e == selected
              is_selected = true
              '<option value="%s" selected="selected">%s</option>'
            else
              '<option value="%s">%s</option>'
            end
          sprintf(format, value, h(name))
        }
        option_tags.
          unshift(sprintf("<option%s>&nbsp;</option>",
                          is_selected ?
                            '' :
                            ' selected="selected"'))
        return desc + select_tag(@fieldname, option_tags.join,
                                 :include_blank => true)
      end
    end
  end
end
