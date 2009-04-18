module GScript
  class GsItem < GsBase
    attr_reader :_item, :actor

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
      @actor = actor
      @_item = @actor.items.find_by_iname(iname.to_s)
      unless @_item
        raise(ItemNotFound,
              _e("Item not found (actor: #{actor.login}, item: #{iname})"))
      end
    end
    def value=(v)
      @_item.value = v
      @_item.save!
      return @_item.value
    end
    def to_s
      value.to_s
    end
    def method_missing(name, *args)
      if @_item.respond_to?(name)
        return @_item.send(name, *args)
      end
      super
    end
    def marshal_dump
      [@actor.login, @_item.iname]
    end
    def marshal_load(data)
      login, iname = *data
      @actor = GsEngine.current_engine.actor(login)
      @_item = @actor.send(iname)._item
    end
  end
end
