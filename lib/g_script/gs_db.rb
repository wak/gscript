require 'csv'

module GScript
  class GsDB < GsBase
    class << self
      def init_db
				# if @@actor_category is true
				#   use actors.yml's categories field
				# else
				#   use categories.yml's actors field
				@@actor_category = true

				if @@actor_category
					init_categories
					init_actors
				else
					init_actors
					init_categories
				end
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
          data[:value_type] = data['type']
          data[:value] = 0
          if data['type'] == 'int'
            data[:value] = (data['default'] || 0).to_i
          else
            data[:value] = (data['default'] || '')
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
              new_item = actor.items.new
              new_item.value_type = data[:value_type]
              new_item.attributes = data
              new_item.save!
            end
          }
        }
      end
      def init_categories
        Category.destroy_all
        load_gs_yaml('categories').each {|iname, data|
          data[:iname] = iname
					as = strorary_to_ary(data['actors'] || [])
					data.delete('actors')
					unless @@actor_category
						data[:actors] = as.map {|a|
							actor = Actor.find_by_login(a)
							raise RuleError, _e("Actor '#{a}' not exist") unless actor
							actor
						}
					end
          Category.create!(data)
        }
      end
      def init_actors
        Actor.destroy_all
        categories = Hash.new {|h, k| h[k] = Array.new }
        load_gs_yaml('actors').each {|login, data|
          data[:login] = login
          cs = data['categories']
          data.delete('categories')
          new_actor = Actor.create!(data)
          strorary_to_ary(cs).each {|c| categories[c] << new_actor }
        }
				return unless @@actor_category
        categories.each {|iname, actors|
          c = Category.find_by_iname(iname)
          raise RuleError, _e("Category '#{iname}' not exist") unless c
          c.actors = actors.uniq
        }
      end
      def init_actions
        Action.destroy_all
        Dir.glob("#{RAILS_ROOT}/lib/actions/*.rb").map {|path|
          action = Action.new
          name = path.slice(/\A.*?([a-z_]+)\.rb\z/, 1)
          klass = GScript::GsActionSpace.action_class(name)
          action.iname = klass._gs_info(:iname)
          action.actors = klass._gs_allowed_actors
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
