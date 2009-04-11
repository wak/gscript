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
              @@logger.#{val}(s)
              return s
          end
          def #{key}(s)
            @@logger.#{val}(s)
              return s
          end
        }
      }
    end
  end
end
