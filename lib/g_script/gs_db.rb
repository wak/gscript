require 'csv'

module GScript
  class GsDB < GsBase
    class << self
      def init_db
        init_categories
        init_actors
        init_actions
        init_items
      end
      def init_items
        Item.destroy_all
        load_gs_yaml('items').each {|iname, data|
          iname = data['iname'] if data['iname']
          actors =
            if data['actor'] == 'all'
              Actor.all
            else
              Actor.find(:all,
                         :conditions => {
                           :login => strorary_to_ary(data['actor'])
                         })
            end
          if data['type'] == 'int'
            data[:value_type] = 'i'
            data[:ivalue] = (data['default'] || 0).to_i
          else
            data[:value_type] = 's'
            data[:svalue] = (data['default'] || '')
          end
          ['type', 'default', 'actor', 'iname'].each {|key|
            data.delete(key)
          }
          data[:iname] = iname
          actors.each {|actor|
            item = actor.items.find_by_iname(iname)
            if item
              item.update_attributes(data)
            else
              actor.items.create!(data)
            end
          }
        }
      end
      def init_categories
        Category.destroy_all
        load_gs_yaml('categories').each {|iname, data|
          data[:iname] = iname
          Category.create!(data)
        }
      end
      def init_actors
        Actor.destroy_all
        categories = Hash.new {|h, k| h[k] = Array.new }
        load_gs_yaml('actors').each {|login, data|
          data[:login] = login
          cs = data['category']
          data.delete('category')
          new_actor = Actor.create!(data)
          strorary_to_ary(cs).each {|c| categories[c] << new_actor }
        }
        categories.each {|iname, actors|
          c = Category.find_by_iname(iname)
          raise _e("Bad category (actors.yml): '#{iname}'") unless c
          c.actors = actors.uniq
        }
      end
      def init_actions
        Action.destroy_all
        Dir.glob("#{RAILS_ROOT}/lib/actions/*.rb").map {|path|
          action = Action.new
          name = path.slice(/\A.*?([a-z_]+)\.rb\z/, 1)
          action.iname = name
          action.actors =
            GScript::GsActionSpace.action_class(name)._gs_allowed_actors
          action.save!
        }
      end

      private
      def strorary_to_ary(data)
        case data
        when String
          CSV.parse_line(data).map(&:strip)
        when Array
          data.map(&:to_s)
        end
      end
      def load_gs_yaml(filename)
        YAML.load_file("#{RAILS_ROOT}/lib/db/#{filename}.yml")
      end
    end
  end
end