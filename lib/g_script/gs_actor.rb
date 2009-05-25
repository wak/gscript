module GScript
  class GsActor < GsBase
    attr_reader :_items
    def initialize(login)
      @_login = login
      @_items = {}
    end
    def _gs_actor
      @_gs_actor ||= Actor.find_by_login(@_login)
    end
    def id; _gs_actor.id; end
    def item(iname)
      iname = iname.to_sym
      @_items[iname] ||= GsItem.new(self, iname)
    end
    def method_missing(name, *args)
      if _gs_actor.respond_to?(name)
        _gs_actor.send(name, *args)
      elsif /(.*)=/ =~ name.to_s
        send($1).value = *args
      else
        item(name)
      end
    end
    def marshal_dump
      _gs_actor.login
    end
    def to_s
      _gs_actor.name
    end
    def marshal_load(login)
      gactor = GScript.current_engine.actor(login)
      @_gs_actor = gactor._gs_actor
      @_items = gactor._items
    end
  end
end
