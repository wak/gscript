class CreateActionLogs < ActiveRecord::Migration
  def self.up
    create_table :action_logs do |t|
      t.references :action, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :action_logs
  end
end
