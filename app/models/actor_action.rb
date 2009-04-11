class ActorAction < ActiveRecord::Base
  belongs_to :actor
  belongs_to :action
end
