class Category < ActiveRecord::Base
  has_many :actor_categories, :dependent => :destroy
  has_many :actors, :through => :actor_categories
end
