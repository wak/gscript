# == Schema Information
# Schema version: 20090411123850
#
# Table name: actions
#
#  id         :integer(4)      not null, primary key
#  iname      :string(255)     not null
#  created_at :datetime
#  updated_at :datetime
#

class Action < ActiveRecord::Base
  has_many :actor_actions, :dependent => :destroy
  has_many :actors, :through => :actor_actions
end
