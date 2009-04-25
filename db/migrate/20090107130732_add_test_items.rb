class AddTestItems < ActiveRecord::Migration
  def self.up
    return

    items = [{:iname => 'fund'},
             {:iname => 'power'},
             {:iname => 'population'}]
    actors = Actor.find(:all)
    items.each {|attr|
      attr[:name] = attr[:iname]
      actors.each{|actor|
        actor.items.create(attr)
      }
    }
  end

  def self.down
  end
end
