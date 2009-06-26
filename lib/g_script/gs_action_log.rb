module GScript
  class GsActionLog < GsBase
    attr_accessor :active_actor, :active_actors
    attr_accessor :passive_actor, :passive_actors
    attr_writer :_gs_action_log

    def active_actor=(a)
      @active_actor = a
    end
    def initialize
      @changes = Hash.new
      @active_actor   = nil
      @active_actors  = []
      @passive_actor  = nil
      @passive_actors = []
      @_gs_action_log = nil
    end
    def change(item, before, after)
      key = "#{item.actor.login}.#{item.iname}"
      change = @changes[key]
      unless change
        change = @changes[key] = {}
        change[:item_id] = item._gs_item.id
        change[:actor_id] = item.actor._gs_actor.id
        change[:value_type]  = item.value_type
        change[:before_value] = before
        _d sprintf("[debug] %s.%s", item.actor.name, item.name)
      end
      change[:after_value] = after
    end
    def write
      @_gs_action_log ||= ActionLog.new

      actives = active_actors
      actives << active_actor if active_actor
      passives = passive_actors
      passives << passive_actor if passive_actor
      if actives.empty? && passives.empty? && @changes.empty?
        return
      end
      @_gs_action_log.active_actors = actives.uniq.map(&:_gs_actor)
      @_gs_action_log.passive_actors = passives.uniq.map(&:_gs_actor)
      @_gs_action_log.action =
        Action.find_by_iname(GScript.current_engine._gs_info(:iname))

      @changes.each {|item, c|
        change = @_gs_action_log.changes.build
        change.value_type = c[:value_type]
        change.attributes = c
        m = sprintf("%s.%s: %s => %s",
                    c[:actor_id], item,
                    c[:before_value], c[:after_value])
        _d m
      }
      @_gs_action_log.save!
    end
  end
end
