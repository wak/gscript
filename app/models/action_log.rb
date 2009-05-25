# == Schema Information
# Schema version: 20090525100458
#
# Table name: action_logs
#
#  id         :integer(4)      not null, primary key
#  action_id  :integer(4)      not null
#  created_at :datetime
#  updated_at :datetime
#

class ActionLog < ActiveRecord::Base
  has_many(:changes,
           :class_name => 'ActionLogChange',
           :dependent => :destroy)
  belongs_to :action

  has_many(:_log_actors_active,
           :class_name => 'ActionLogActor',
           :dependent => :destroy,
           :conditions => {:active => true})
  has_many(:_log_actors_passive,
           :class_name => 'ActionLogActor',
           :dependent => :destroy,
           :conditions => {:active => false})
  has_many(:active_actors,
           :source => :actor,
           :through => :_log_actors_active)
  has_many(:passive_actors,
           :source => :actor,
           :through => :_log_actors_passive)

  alias _active_actors= active_actors=
  alias _passive_actors= passive_actors=

  def active_actors=(actors)
    actors.map {|a|
      _log_actors_active.build(:actor => a)
    }
  end
  def passive_actors=(actors)
    actors.map {|a|
      _log_actors_passive.build(:actor => a)
    }
  end
end
