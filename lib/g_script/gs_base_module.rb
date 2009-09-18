module GScript
  module GsBaseModule
    ft = Logger::Formatter.new
    ft.datetime_format = "%Y/%m/%d %H-%M-%S "
    @@logger = Logger.new("#{RAILS_ROOT}/log/gscript.log")
    @@logger.level = Logger::DEBUG
    @@logger.formatter = ft
    @@logger.progname = 'GScript'
    def self.included(klass)
      { :_f => :fatal,
        :_e => :error,
        :_w => :warn,
        :_i => :info,
        :_d => :debug }.each {|key, val|
        klass.class_eval %Q{
          def self.#{key}(s)
            @@logger.#{val}(_log_edit(s))
            return s
          end
          def #{key}(s)
            @@logger.#{val}(_log_edit(s))
              return s
          end
        }
      }
      klass.class_eval %q{
        def self._log_edit(s)
          "#{self.name.slice(/([[:alpha:]]+)\Z/, 1)}: " + s
        end
        def _log_edit(s)
          "#{self.class.name.slice(/([[:alpha:]]+)\Z/, 1)}: " + s
        end
      }
    end
  end
end
