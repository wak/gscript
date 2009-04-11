class CreateActorActions < ActiveRecord::Migration
  def self.up
    create_table :actor_actions do |t|
      t.references :actor,  :null => false
      t.references :action, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :actor_actions
  end
end
