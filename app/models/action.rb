class Action < ActiveRecord::Base
  has_many :actor_actions, :dependent => :destroy
  has_many :actors, :through => :actor_actions
end
