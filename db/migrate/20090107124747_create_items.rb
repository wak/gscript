class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.references :actor, :null => false
      t.string  :iname,    :null => false
      t.string  :name,     :null => false, :default => ''
      t.integer :v_int
      t.string  :v_string
      t.boolean :v_bool
      t.string  :_value_type, :null => false
      t.timestamps
    end
#     execute <<-EOS
#       ALTER TABLE items
#         ADD CONSTRAINT fk_items_actor_ids
#         FOREIGN KEY (actor_id) REFERENCES actors(id)
#     EOS
  end

  def self.down
    drop_table :items
  end
end
