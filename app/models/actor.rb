# == Schema Information
# Schema version: 20090411123850
#
# Table name: actors
#
#  id         :integer(4)      not null, primary key
#  login      :string(255)     not null
#  name       :string(255)     default(""), not null
#  created_at :datetime
#  updated_at :datetime
#

class Actor < ActiveRecord::Base
  has_many :items
  has_many :files, :class_name => 'GFile', :order => 'id DESC'

  has_many :actor_actions
  has_many(:actions,
           :through => :actor_actions,
           :dependent => :destroy)

  has_many :actor_categories
  has_many(:categories,
           :through => :actor_categories,
           :dependent => :destroy)
end
