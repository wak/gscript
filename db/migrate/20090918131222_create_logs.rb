class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.references :actor, :null => false
      t.string :message, :null => false, :default => ""

      t.timestamps
    end
  end

  def self.down
    drop_table :logs
  end
end
