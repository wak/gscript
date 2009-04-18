module GScript
  module GsField
    class GsTextField < GsFieldBase
      def initialize(name, type, option={}, &verify)
        super(name, type, option, &verify)
      end
      def generate
        desc = option(:desc)
        desc = desc ? "#{h(desc)}: " : ''
        default = (@value ? @value : option(:value))
        if option(:multi)
          desc +
            text_area_tag(@fieldname,
                          default,
                          option_hash(:rows, :cols, :size, :disabled))
        else
          desc +
            text_field_tag(@fieldname,
                           default,
                           option_hash(:maxlength, :size, :disabled))
        end
      end
    end
  end
end
