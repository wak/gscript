class CreateReadies < ActiveRecord::Migration
  def self.up
    create_table :readies do |t|
      t.string :action
      t.text :gscript
      t.timestamps
    end
  end

  def self.down
    drop_table :readies
  end
end
