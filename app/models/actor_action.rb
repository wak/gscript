# == Schema Information
# Schema version: 20090525100458
#
# Table name: actor_actions
#
#  id         :integer(4)      not null, primary key
#  actor_id   :integer(4)      not null
#  action_id  :integer(4)      not null
#  created_at :datetime
#  updated_at :datetime
#

class ActorAction < ActiveRecord::Base
  belongs_to :actor
  belongs_to :action
end
