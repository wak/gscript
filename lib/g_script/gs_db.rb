module GScript
  class GsDB < GsBase
    class << self
      def init_db
        init_actors
        init_actions
        init_items
      end
      def init_items
        Item.destroy_all
        load_gs_yaml('items').each {|iname, data|
          actors = if data['actor'] == 'all'
                     Actor.all
                   else
                     Actor.find(:all,
                                :conditions => {
                                  :login => data['actor']
                                })
                   end
          actors.each {|actor|
            actor.items.create!(:iname => iname,
                                :name => data['name'])
          }
        }
      end
      def init_actors
        Actor.destroy_all
        load_gs_yaml('actors').each {|login, data|
          Actor.create!(:login => login, :name => data['name'])
        }
      end
      def init_actions
        Action.destroy_all
        Dir.glob("#{RAILS_ROOT}/lib/actions/*.rb").map {|path|
          action = Action.new
          name = path.slice(/\A.*?([a-z_]+)\.rb\z/, 1)
          action.iname = name
          action.actors = GScript.action_class(name)._gs_allowed_actors
          action.save!
        }
      end

      private
      def load_gs_yaml(filename)
        YAML.load_file("#{RAILS_ROOT}/lib/db/#{filename}.yml")
      end
    end
  end
end
