class CreateActorCategories < ActiveRecord::Migration
  def self.up
    create_table :actor_categories do |t|
      t.references :actor,    :null => false
      t.references :category, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :actor_categories
  end
end
