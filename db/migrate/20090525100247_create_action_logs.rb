class CreateActionLogs < ActiveRecord::Migration
  def self.up
    create_table :action_logs do |t|
      t.references :action, :null => false
      t.references :actor,  :null => false
      t.boolean    :canceled, :null => false, :default => false
      t.string     :status,   :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :action_logs
  end
end
