class CreateActors < ActiveRecord::Migration
  def self.up
    create_table :actors do |t|
      t.string :login, :null => false
      t.string :name,  :null => false, :default => ''
      t.timestamps
    end
  end

  def self.down
    drop_table :actors
  end
end
