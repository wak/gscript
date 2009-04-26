require 'csv'

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
          data.delete('type')
          data.delete('default')
          data.delete('actor')
          data[:iname] = iname
          actors.each {|actor|
            actor.items.create!(data)
          }
        }
      end
      def init_actors
        Actor.destroy_all
        load_gs_yaml('actors').each {|login, data|
          Actor.create!(:login => login, :name => data['name'])
        }
      end
      def action_class(name)
        name = name.underscore
        @@actions ||= {}
        return @@actions[name] if @@actions.key?(name)

        path = "#{RAILS_ROOT}/lib/actions/#{name}.rb"
        unless File.file?(path)
          raise _e("Action file '#{path}' not found.")
        end
        GScript::GsActionSpace.class_eval(File.read(path), path)
        begin
          class_name = name.classify
          action = GScript::GsActionSpace.const_get(class_name)
        rescue
          raise _e("Action '#{class_name}' not defined.")
        end
        raise "Action Not Defined" unless action
        @@actions[name] = action
      end
      def init_actions
        Action.destroy_all
        Dir.glob("#{RAILS_ROOT}/lib/actions/*.rb").map {|path|
          action = Action.new
          name = path.slice(/\A.*?([a-z_]+)\.rb\z/, 1)
          action.iname = name
          action.actors = action_class(name)._gs_allowed_actors
          action.save!
        }
      end

      private
      def strorary_to_ary(data)
        case data
        when String
          CSV.parse_line(text).map(&:strip)
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
