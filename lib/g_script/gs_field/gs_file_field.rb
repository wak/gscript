module GScript
  module GsField
    class GsFileField < GsFieldBase
      def initialize(name, type, option={}, &verify)
        super(name, type, option, &verify)
      end
      def generate
        desc = option(:message)
        desc = desc ? "#{h(desc)}: " : ''
        desc + file_field_tag("#{@fieldname}[uploaded_data]",
                              option_hash)
      end
    end
  end
end
