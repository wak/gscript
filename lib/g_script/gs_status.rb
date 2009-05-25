module GScript
  class GsStatus < GsBase
    attr_reader :mode, :log
    attr_writer :changed

    def initialize
      reset
      @log = GsActionLog.new
    end
    def change(mode, options={})
      unless [:continue, :input, :ready,
              :cancel, :finish, :send_file].member?(mode)
        raise _e("GStatus#change: unknown mode(=#{mode})")
      end
      @changed = true
      @mode = mode
      @options[:method] = options[:method] if options.key?(:method)
      case mode
      when :send_file
        @options[:file] = options[:file]
      when :ready
        @options[:actor] = options[:actor]
        @options[:message] = options[:message]
        @options[:selection] = (options[:selection] || [])
      end
      return mode
    end
    def reset
      @changed = false
      @options = {}
      @mode = :continue
      @options[:method] = :start
    end
    def changed?; @changed; end
    def ==(mode); @mode == mode; end
    def inspect
      "mode: '#{@mode}', method '#{@method}'"
    end
    def option(name)
      @options[name]
    end
    def _gs_action=(t)
      @log = t
    end
  end
end
