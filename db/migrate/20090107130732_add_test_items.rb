class AddTestItems < ActiveRecord::Migration
  def self.up
    items = [{:iname => 'fund'},
             {:iname => 'power'},
             {:iname => 'population'}]
    actors = Actor.find(:all)
    items.each {|attr|
      actors.each{|actor|
        actor.items.create(attr)
      }
    }
  end

  def self.down
  end
end
