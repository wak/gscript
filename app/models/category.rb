# == Schema Information
# Schema version: 20090411123850
#
# Table name: categories
#
#  id         :integer(4)      not null, primary key
#  iname      :string(255)     not null
#  created_at :datetime
#  updated_at :datetime
#

class Category < ActiveRecord::Base
  has_many :actor_categories, :dependent => :destroy
  has_many :actors, :through => :actor_categories
end
