module GScript
  class GsActor < GsBase
    attr_reader :_items
    def initialize(login)
      @_login = login
      @_items = {}
    end
    def _actor
      @_actor ||= Actor.find_by_login(@_login)
    end
    def id; _actor.id; end
    def item(iname)
      iname = iname.to_sym
      @_items[iname] ||= GsItem.new(self, iname)
    end
    def method_missing(name, *args)
      if _actor.respond_to?(name)
        _actor.send(name, *args)
      elsif /(.*)=/ =~ name.to_s
        send($1).value = *args
      else
        item(name)
      end
    end
    def marshal_dump
      _actor.login
    end
    def to_s
      _actor.name
    end
    def marshal_load(login)
      gactor = GScript.current_engine.actor(login)
      @_actor = gactor._actor
      @_items = gactor._items
    end
  end
end
