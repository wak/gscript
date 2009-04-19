class CreateReadies < ActiveRecord::Migration
  def self.up
    create_table :readies do |t|
      t.references :actor,  :null => false

      t.text   :_selection, :null => false
      t.string :action,     :null => false
      t.text   :gscript,    :null => false
      t.text   :message,    :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :readies
  end
end
