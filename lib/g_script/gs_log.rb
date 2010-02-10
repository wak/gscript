module GScript
  class GsLog < GsBase
    @@styles = Hash.new {|h, n| h[n] = {} }
    class << self
      def add_style(level, sub_level, options={}, &block)
        raise RuleError, _e("add_style requre block") unless block
        options[:block] = block
        @@styles[level][sub_level] = options
      end
      def get_style(level, sub_level)
        @@styles[level][sub_level] || nil
      end
      def write_log(level, sub_level, options={})
        args = options[:args] || []
        style = get_style(level, sub_level)
        unless style
          raise RuleError, _e("Style #{level.to_s}:#{sub_level.to_s} not defined")
        end
        if style[:requires] && args && !(style[:requires] - args.keys).empty?
          raise RuleError, _e("#{level.to_s}:#{sub_level.to_s} miss argments (#{style[:requires] - args.keys}).")
        end
        options[:to].each {|actor|
          actor.write_log(style[:block].call(actor, args))
        }
      end
    end
  end
  Db::LogStyle # load styles
end
