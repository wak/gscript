module GScript
  class GsActionLog < GsBase
    attr_accessor :active_actor, :status
#     attr_accessor :passive_actor, :passive_actors

    def active_actor=(a)
      @active_actor = a
    end
    def initialize
      @changes = Hash.new
      @active_actor = nil
      @status = nil
      @action_log = nil
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
      @action_log ||= ActionLog.new
      @action_log.status = @status
      @action_log.actor = @active_actor._gs_actor
      @action_log.action =
        Action.find_by_iname(GScript.current_engine._gs_info(:iname))

      @changes.each {|item, c|
        change =
          @action_log.
            changes.find(:first,
                         :conditions => {
                           :actor_id => c[:actor_id],
                           :item_id => c[:item_id]
                         })
        change = @action_log.changes.build unless change
        change.value_type = c[:value_type]
        change.attributes = c
        change.save! unless change.new_record?
        m = sprintf("%s.%s: %s => %s",
                    c[:actor_id], item,
                    c[:before_value], c[:after_value])
        _d m
      }
      @action_log.save!
    end
    def marshal_dump
      {
        :log_id => @action_log.nil? ? nil : @action_log.id,
        :changes => @changes,
        :active_actor => @active_actor
      }
    end
    def marshal_load(data)
      @changes = data[:changes]
      @active_actor = data[:active_actor]
      if data[:log_id].nil?
        @action_log = nil
      else
        @action_log = ActionLog.find(data[:log_id])
      end
    end
  end
end
