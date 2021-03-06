module GScript
  class GsEngine < GsBase
    attr_reader :_gs_fields, :ready, :status

    def initialize
      _d "Action created."
      actors = Actor.find(:all, :select => 'login')
      @status = GsStatus.new
      @ready = nil
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
      }
      return nil
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
    def change(mode, options={})
      @status.change(mode, options)
    end
    def clear_fields
      @_gs_fields = []
    end
    def input(field)
      data = @_gs_input[field]
			unless data
				raise RuleError, "Input data '#{field}' not defined"
			end
			return data
    end
		alias :get_input :input
    def actor(act)
      actor = @actorhash[act.to_s]
			unless actor
				raise ActorNotFound, _e("Actor '#{act}' not found")
			end
			return actor
    end
		alias :get_actor :actor
    def actors(*acts)
      return @actors if acts.empty?
      acts.map {|t| actor(t) }
    end
		alias :get_actors :actors
    def actors_ex
      get_actors - [@current]
    end
		alias :get_actors_ex :actors_ex
    def actor_c(*cats)
      cats = cats.map(&:to_s)
      categories =
        Category.find(:all,
                      :conditions => {:iname => cats})
      return categories.map(&:actors).flatten.uniq.map{|a| get_actor(a.login) }
    end
		alias :get_actor_c :actor_c
    def actor_c_ex(*cats)
      get_actor_c(*cats) - [@current]
    end
		alias :get_actor_c_ex :actor_c_ex
    def ready=(selected)
      @status.option(:selection).each_slice(2) {|key, value|
        if value.to_s == selected
          @ready = key
          break
        end
      }
      unless @ready
        raise SystemError, _e("Bad ready selected. (#{selected})")
      end
      return @ready
    end
    def current=(actor)
      login = (actor.is_a?(Actor) ? actor.login : actor)
      @current = actor(login)
    end
		def gformat(name, args = {})
			Db::GFormat.new(name, args).result
		end
    def write_log(sub_lv, options={})
      lv = _gs_info(:iname_small)
      GScript::GsLog.write_log(lv.to_sym, sub_lv, options)
    end
    #*******************************************************
    #  Follow methods for GScript system
    #
    def _gs_field(klass, name, type, option, &verify)
      if @_gs_fields.any? {|f| f.name == name }
        raise RuleError, _e("Field '#{name}' already defined.")
      end
      @_gs_fields << klass.new(name, type, option, &verify)
    end
    def _gs_execute(&block)
      if @status.mode == :start
        @status.log.active_actor = @current
        @status.change(:continue, :method => :start)
      end
      GScript.current_engine = self
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
        send(@status.option(:method))
      end while after.call
      if [:finish, :cancel].include?(@status.mode)
        @status.log.status = @status.mode.to_s
        @status.log.write
      end
      return @status.mode
    ensure
      GScript.current_engine = self
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
      unless @status.mode == :ready
        raise SystemError, _e('Cannot save status. (not :ready mode)')
      end
      @_gs_ready ||= Ready.new
      @_gs_ready.gscript =
        Marshal.dump({ :status => @status, :user => @user })
      @_gs_ready.action = _gs_info(:iname)
      selection = []
      @_gs_ready.selection =
        @status.option(:selection).each_slice(2).map(&:last)
      unless @status.option(:actor)
        raise SystemError, _e('GScript(:ready): Ready actor not selected.')
      end
      @_gs_ready.message = @status.option(:message)
      @_gs_ready.actor = @status.option(:actor)._gs_actor
      @_gs_ready.save!
      return @_gs_ready
    end

    def _gs_load(ready)
      @_gs_ready = ready
      GScript.current_engine = self
      tmp = Marshal.load(ready.gscript)
      GScript.current_engine = nil
      @status = tmp[:status]
      @user = tmp[:user]
      _d "Load (#{@status.inspect})"
      return self
    end
  end
end
