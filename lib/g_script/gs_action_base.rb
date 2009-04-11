module GScript
  class GsActionBase < GsEngine
    class << self
      def allow_actor(*actors)
        write_inheritable_attribute(:allow_actors, actors)
      end
      def _gs_allowed_actors
        aactors = read_inheritable_attribute(:allow_actors)
        unless aactors
          return Actor.find(:all)
        end
        aactors = aactors.map {|t| t.to_s }
        return Actor.find(:all,
                          :conditions => {
                            :login => aactors
                          })
      end
    end
    def action_name
      info(:iname)
    end
  end
end

