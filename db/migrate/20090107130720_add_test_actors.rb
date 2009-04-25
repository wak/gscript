class AddTestActors < ActiveRecord::Migration
  def self.up
    return

    actors = {
      :america => 'Americal',
      :japan => 'Japan',
      :china => 'China',
      :rits => 'Ritsumei',
      :mit => 'MIT',
      :toyota => 'Toyota',
      :mitsubishi => 'Mitsubishi',
      :special => 'SPECIAL'
    }
    actors.each {|login, name|
      Actor.create(:login => login.to_s, :name => name)
    }
  end

  def self.down
  end
end
