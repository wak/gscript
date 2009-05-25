module GScript
  class GsItem < GsBase
    attr_reader :_gs_item, :actor

    ['-', '+', '*', '/', '%',
     '<', '>', '<=', '>='].each {|op|
      class_eval %Q{
        def #{op}(v)
          case v
          when Integer
            value #{op} v
          when GsItem
            if iname != v.iname
              raise sprintf("Mismatch operands '%s #{op} %s'",
                            to_s, v.to_s)
            end
            value #{op} v.value
          end
        end
      }
    }
    def ==(obj)
      return value == v if obj.is_a?(Integer)
      return equal?(obj)
    end
    def initialize(actor, iname)
      @old_value = nil
      @actor = actor
      @_gs_item = @actor.items.find_by_iname(iname.to_s)
      unless @_gs_item
        raise(ItemNotFound,
              _e("Item not found (actor: #{actor.login}, item: #{iname})"))
      end
    end
    def value=(v)
      old_value = @_gs_item.value
      @_gs_item.value = v
      @_gs_item.save!
      unless @old_value
        @old_value = old_value
        GScript.current_engine.
          status.log.change(self, old_value, value)
      end
      return @_gs_item.value
    end
    def old_value
      @old_value || value
    end
    def to_s
      value.to_s
    end
    def method_missing(name, *args)
      if @_gs_item.respond_to?(name)
        return @_gs_item.send(name, *args)
      end
      super
    end
    def marshal_dump
      [@actor.login, @_gs_item.iname]
    end
    def marshal_load(data)
      login, iname = *data
      @actor = GScript.current_engine.actor(login)
      @_gs_item = @actor.send(iname)._gs_item
    end
  end
end
