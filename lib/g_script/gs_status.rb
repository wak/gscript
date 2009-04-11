module GScript
  class GsStatus < GsBase
    attr_reader :mode, :method, :file
    attr_writer :changed
    def initialize(gscript)
      @gscript = gscript
      reset
    end
    def change(mode, option={})
      unless [:continue, :input,
              :ready, :finish, :send_file].member?(mode)
        raise _e("GStatus#change: unknown mode(=#{mode})")
      end
      @changed = true
      @mode = mode
      @method = option[:method] if option.key?(:method)
      case mode
      when :send_file
        @file = option[:file] if option.key?(:file)
      end
      return mode
    end
    def reset
      @changed = false
      @mode = :continue
      @method = :start
    end
    def changed?; @changed; end
    def ==(mode); @mode == mode; end
    def inspect
      "mode: '#{@mode}', method '#{@method}'"
    end
  end
end
