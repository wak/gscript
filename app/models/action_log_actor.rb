# == Schema Information
# Schema version: 20090525100458
#
# Table name: action_log_actors
#
#  id            :integer(4)      not null, primary key
#  action_log_id :integer(4)      not null
#  actor_id      :integer(4)      not null
#  active        :boolean(1)      not null
#  created_at    :datetime
#  updated_at    :datetime
#

class ActionLogActor < ActiveRecord::Base
  belongs_to :action_log, :class_name => 'ActionLog'
  belongs_to :actor
end
