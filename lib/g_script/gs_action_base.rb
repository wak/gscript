module GScript
  class GsActionBase < GsEngine
    class << self
      def allow_actor(*actors)
        write_inheritable_attribute(:allow_actors, actors)
      end
      def allow_category(*categories)
        write_inheritable_attribute(:allow_categories, categories)
      end
      def allow_all
        write_inheritable_attribute(:allow_all, true)
      end

      def _gs_allowed_actors
        allow_all = read_inheritable_attribute(:allow_all)
        return Actor.all if allow_all

        actors = read_inheritable_attribute(:allow_actors)
        cats = read_inheritable_attribute(:allow_categories)

        actors = actors.to_a.map(&:to_s)
        cats = cats.to_a.map(&:to_s)
        actors =
          Actor.find(:all,
                     :conditions => {:login => actors})
        categories =
          Category.find(:all,
                        :conditions => {:iname => cats})
        categories.each {|c| actors += c.actors }
        return actors.uniq
      end
    end
    def action_name
      info(:iname)
    end
  end
end
