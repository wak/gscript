class CreateActions < ActiveRecord::Migration
  def self.up
    create_table :actions do |t|
      t.string :iname, :null => false
      t.string :name,  :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :actions
  end
end
