module GScript
  class GsActionLog < GsBase
#     attr_accessor :active_actor, :active_actors
#     attr_accessor :passive_actor, :passive_actors
    attr_writer :_gs_action_log

    def active_actor=(a)
      @active_actor = a
    end
    def initialize
      @changes = Hash.new
#       @active_actor   = nil
#       @active_actors  = []
#       @passive_actor  = nil
#       @passive_actors = []
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

#       actives = active_actors
#       actives << active_actor if active_actor
#       passives = passive_actors
#       passives << passive_actor if passive_actor
#       if actives.empty? && passives.empty? && @changes.empty?
#         return
#       end
#       @_gs_action_log.active_actors = actives.uniq.map(&:_gs_actor)
#       @_gs_action_log.passive_actors = passives.uniq.map(&:_gs_actor)
      @_gs_action_log.action =
        Action.find_by_iname(GScript.current_engine._gs_info(:iname))

      @changes.each {|item, c|
        change =
          @_gs_action_log.
            changes.find(:first,
                         :conditions => {
                           :actor_id => c[:actor_id],
                           :item_id => c[:item_id]
                         })
        change = @_gs_action_log.changes.build unless change
        change.value_type = c[:value_type]
        change.attributes = c
        change.save! unless change.new_record?
        m = sprintf("%s.%s: %s => %s",
                    c[:actor_id], item,
                    c[:before_value], c[:after_value])
        _d m
      }
      @_gs_action_log.save!
    end
    def marshal_dump
      {:log_id => @_gs_action_log.nil? ? nil : @_gs_action_log.id,
        :changes => @changes}
    end
    def marshal_load(data)
      @changes = data[:changes]
      if data[:log_id].nil?
        @_gs_action_log = nil
      else
        @_gs_action_log = ActionLog.find(data[:log_id])
      end
    end
  end
end
