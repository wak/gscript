module GScript::GsAction
  class GenericAction < GScript::GsEngine
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
      def get_action_name
        read_inheritable_attribute(:action_name) || _gs_iname
      end
      def get_action_desc
        read_inheritable_attribute(:action_desc) || ''
      end
      def action_name(name)
        write_inheritable_attribute(:action_name, name)
      end
      def action_desc(desc)
        write_inheritable_attribute(:action_desc, desc)
      end

      def _gs_iname
        self.name.slice(/\A.*?([a-z0-9_]+)\z/i, 1)
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
      def _gs_info(key = nil)
        attrs = {
          :iname => _gs_iname,
          :iname_small => _gs_iname.underscore,
          :iname_large => _gs_iname,
          :name  => get_action_name,
          :desc  => get_action_desc
        }
        return key ? attrs[key] : attrs
      end
    end
    def _gs_info(key = nil)
      self.class._gs_info(key)
    end
    def action_name
      _gs_info(:name)
    end
    def action_desc
      _gs_info(:desc)
    end
  end
end
