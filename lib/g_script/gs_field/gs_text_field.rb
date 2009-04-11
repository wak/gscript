module GScript
  module GsField
    class GsTextField < GsFieldBase
      def initialize(name, type, option={}, &verify)
        super(name, type, option, &verify)
      end
      def generate
        desc = @option[:desc]
        desc = desc ? "#{h(desc)}: " : ''
        if @option[:multi]
          desc +
            text_area_tag(@fieldname,
                          @option[:value],
                          get_options(:rows, :cols, :size, :disabled))
        else
          desc +
            text_field_tag(@fieldname,
                           @option[:value],
                           get_options(:maxlength, :size, :disabled))
        end
      end
    end
  end
end
