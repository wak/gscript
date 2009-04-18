module GScript
  class GsEngine < GsBase
    attr_reader :_gs_fields

    def self.current_engine=(engine)
      @@current_engine = engine
    end
    def self.current_engine
      @@current_engine
    end
    def initialize
      _d "GScript Initialize"
      actors = Actor.find(:all, :select => 'login')
      @status = GsStatus.new(self)
      @user = {}
      @actors = []
      @current = nil
      @_gs_input = {}
      @_gs_ready = nil
      @_gs_fields = []
      @actorhash = {}
      actors.each {|actor|
        gactor = GsActor.new(actor.login)
        @actors << gactor
        @actorhash[actor.login] = gactor
        #instance_variable_set("@#{actor.login}", gactor)
      }
      return nil
    end
    def info(key = nil)
      attrs = {
        :iname => self.class.name.slice(/\A.*?([a-z0-9_]+)\z/i, 1)
      }
      return key ? attrs[key] : attrs
    end
    def method_missing(name, *args)
      super
    end
    def file_field(name, option={}, &verify)
      _gs_field(GsField::GsFileField, name, :file, option, &verify)
    end
    def text_field(name, type, option={}, &verify)
      _gs_field(GsField::GsTextField, name, type, option, &verify)
    end
    def select_field(name, type, option={}, &verify)
      _gs_field(GsField::GsSelectField, name, type, option, &verify)
    end
    def clear_fields
      @_gs_fields = []
    end
    def input(field)
      @_gs_input[field]
    end
    def actor(act)
      @actorhash[act.to_s]
      #instance_variable_get("@#{actor}")
    end
    def actors(*acts)
      return @actors if acts.empty?
      acts.map {|t| actor(t) }
    end
    def actor_c(*cats)
      cats = cats.to_a.map(&:to_s)
      categories =
        Category.find(:all,
                      :conditions => {:iname => cats})
      return categories.map(&:actors).flatten.uniq
    end
    def current=(actor)
      login = (actor.is_a?(Actor) ? actor.login : actor)
      @current = actor(login)
    end

    #*******************************************************
    #  Follow methods for GScript system
    #
    def _gs_field(klass, name, type, option, &verify)
      if @_gs_fields.any? {|f| f.name == name }
        raise "Field '#{name}' already defined."
      end
      @_gs_fields << klass.new(name, type, option, &verify)
    end
    def _gs_execute(&block)
      before = Proc.new {
        @status.changed = false
      }
      after = Proc.new {
        @status.change(:finish,
                       :method => nil) unless @status.changed?
        @status.changed = false
        @status.mode == :continue
      }
      script_info = ''
      if block_given?
        before.call
        instance_eval &block
        return @status.mode unless after.call
      end
      begin
        before.call
        script_info = @status.inspect
        _i "Execute (#{script_info})"
        send(@status.method)
      end while after.call
      return @status.mode
    rescue
      _e "Errors in script (#{script_info})"
      raise
    end
    def _gs_input_set(key, val)
      field = @_gs_fields.find {|f| f == key }
      return false unless field
      field.set_value(self, val)
      #field.valid?
      #field.value
      @_gs_input[field.name] = field.value
      #t = @_gs_input[field.name] = field.value if field.valid?
      #return t
    end
    def _gs_input_valid?
      valid = true
      @_gs_fields.each {|f|
        valid = false unless f.valid?
      }
      return valid
    end
    def _gs_status; @status end
    def _gs_save
      @_gs_ready ||= Ready.new
      @_gs_ready.gscript =
        Marshal.dump({ :status => @status, :user => @user })
      @_gs_ready.action = info(:iname)
      @_gs_ready.save!
    end

    # Don't call this method on Thread.
    # Please run Rails with shared-nothing architecture.
    def _gs_load(ready)
      @_gs_ready = ready
      self.class.current_engine = self
      tmp = Marshal::load(ready.gscript)
      self.class.current_engine = nil
      @status = tmp[:status]
      @user = tmp[:user]
      _d "Load (#{@status.inspect})"
      return self
    end
  end
end
