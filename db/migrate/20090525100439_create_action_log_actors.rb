class CreateActionLogActors < ActiveRecord::Migration
  def self.up
    create_table :action_log_actors do |t|
      t.references :action_log, :null => false
      t.references :actor,      :null => false
      t.boolean    :active,     :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :action_log_actors
  end
end
