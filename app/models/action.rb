# == Schema Information
# Schema version: 20090525100458
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

  has_many :action_logs, :dependent => :destroy

  def gaction
    @action ||= GScript.action_class(iname)
  end
  def name
    gaction.get_action_name
  end
  def desc
    gaction.get_action_desc
  end
end
