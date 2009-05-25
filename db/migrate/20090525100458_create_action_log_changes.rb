class CreateActionLogChanges < ActiveRecord::Migration
  def self.up
    create_table :action_log_changes do |t|
      t.references :action_log, :null => false
      t.references :item,       :null => false
      t.references :actor,      :null => false
      t.string :_value_type, :null => false

      t.integer :vb_int         # Value Before Int
      t.integer :va_int         # Value After Int

      t.string  :vb_string
      t.string  :va_string

      t.boolean :vb_bool
      t.boolean :va_bool

      t.timestamps
    end
  end

  def self.down
    drop_table :action_log_changes
  end
end
