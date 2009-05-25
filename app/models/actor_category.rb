# == Schema Information
# Schema version: 20090525100458
#
# Table name: actor_categories
#
#  id          :integer(4)      not null, primary key
#  actor_id    :integer(4)      not null
#  category_id :integer(4)      not null
#  created_at  :datetime
#  updated_at  :datetime
#

class ActorCategory < ActiveRecord::Base
  belongs_to :actor
  belongs_to :category
end
