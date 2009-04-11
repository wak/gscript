class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.references :actor, :null => false
      t.string  :iname,    :null => false
      t.string  :name,     :null => false, :default => ''
      t.integer :ivalue,   :null => false, :default => 0
      t.string  :svalue,   :null => false, :default => ''
      t.string(:value_type,
               :length => 1, :null => false, :default => 'i')
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
