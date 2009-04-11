class AddTestActors < ActiveRecord::Migration
  def self.up
    actors = {
      :america => 'Americal',
      :japan => 'Japan',
      :china => 'China'
    }
    actors.each {|login, name|
      Actor.create(:login => login.to_s, :name => name)
    }
  end

  def self.down
  end
end
