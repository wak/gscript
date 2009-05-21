module GScript
  class GsChanges < GsBase
    def initialize
      @changes = []
    end
    def add_item(item)
      @changes << item
      out
    end
    def out
      @changes.each {|c|
        m = sprintf("%s.%s: %s => %s",
                    c.actor, c.iname, c.old_value, c.value)
        _d m
      }
    end
  end
end
