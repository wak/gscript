class AddTestCategories < ActiveRecord::Migration
  def self.up
    return

    set = {
      :country => [:japan, :america, :china, :special],
      :school => [:rits, :mit],
      :company => [:toyota, :mitsubishi, :special]
    }
    set.each {|iname, actors|
      actors = Actor.find(:all,
                          :conditions => {
                            :login => actors.map {|a| a.to_s }
                          })
      Category.create!(:iname => iname.to_s, :actors => actors)
    }
  end

  def self.down
  end
end
