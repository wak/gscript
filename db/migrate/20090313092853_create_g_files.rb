class CreateGFiles < ActiveRecord::Migration
  def self.up
    create_table :g_files do |t|
      t.integer :actor_id,     :null => false

      t.integer :size,         :null => false
      t.string  :content_type, :null => false
      t.string  :filename,     :null => false, :default => 'no_name'
      t.integer :db_file_id

      t.timestamps
    end
  end

  def self.down
    drop_table :g_files
  end
end
