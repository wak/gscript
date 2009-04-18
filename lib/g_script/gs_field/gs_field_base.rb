module GScript
  module GsField
    class GsFieldBase < GsBase
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::FormTagHelper

      attr_reader :value, :name, :errors

      DEFAULT_OPTION = {
        :error => {}
      }.freeze
      DEFAULT_ERROR_MESSAGE = {
        :max => "値が大きすぎます．",
        :min => "値が小さすぎます．",
        :range => "範囲外です．",
        :blank => {
          :default => "選択してください．",
          :actor => 'アクターを選択してください．',
          :item => 'アイテムを選択してください．',
          :int => '数値を選択してください．'
        },
        :list => "リストから選択してください．"
      }.freeze

      def initialize(name, type, option={}, &verify)
        @name = name
        @fieldname = "gs_#{name}"
        @type = type
        @options = DEFAULT_OPTION.merge(option)
        new_error = {}
        @options[:error].each {|key, m|
          if key.is_a?(Array)
            key.each {|k| new_error[k] = m }
          else
            new_error[key] = m
          end
        }
        @options[:error] = new_error
        @verify = verify
        @value = nil
        @errors = {}
      end
      def ==(name)
        @fieldname == name.to_s
      end
      def generate; end
      def valid?
        if @value.blank? && !@options[:blank]
          @errors[:blank] = error(:blank)
          return false
        end
        type_valid = "#{type}_valid?"
        return false if respond_to?(type_valid) && !send(type_valid, @value)
        if @verify
          e = @verify.call(@value)
          if e
            @errors[e] = error(e)
            return false
          end
        end
        return true
      end
      def field_to_gs(gs, to, obj)
        result =
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
              gs.actor(login).item(iname) rescue nil
            end
          when :int
            Integer(obj) rescue nil
          end
        return result ? result : false
      end
      def gs_to_field(obj)
        # return [value, name]
        case obj
        when GsActor
          [obj.login, obj.name]
        when GsItem
          ["#{obj.actor.login}.#{obj.iname}", obj.name]
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
      def option_hash(*opts)
        return @options if opts.empty?
        opt = {}
        opts.each {|o|
          opt[o] = @options[o] if @options.key?(o)
        }
        return opt
      end
      def option(name)
        @options[name]
      end
      def error(name)
        mes = @options[:error][name]
        unless mes
          h = DEFAULT_ERROR_MESSAGE[name]
          if h.is_a?(Hash)
            mes = h[@type] || h[:default]
          else
            mes = h
          end
        end
        return mes || 'INVALID'
      end

      private
      def int_valid?(value)
        return true if value.nil?

        ret = true
        if option(:max) && value > option(:max)
          ret = false
          @errors[:max] = error(:max)
        end
        if option(:min) && value > option(:min)
          ret = false
          @errors[:min] = error(:min)
        end
        range = option(:range)
        if range && !range.include?(value)
          ret = false
          if value < range.first
            @errors[:min] = error(:min) ? error(:min) : error(:range)
          elsif value > range.last
            @errors[:max] = error(:max) ? error(:max) : error(:range)
          else
            @errors[:range] = error(:range)
          end
        end
        return ret
      end
    end
  end
end
