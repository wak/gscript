# == Schema Information
# Schema version: 20090525100458
#
# Table name: readies
#
#  id         :integer(4)      not null, primary key
#  actor_id   :integer(4)      not null
#  _selection :text            default(""), not null
#  action     :string(255)     not null
#  gscript    :text            default(""), not null
#  message    :text            default(""), not null
#  created_at :datetime
#  updated_at :datetime
#

require 'csv'

class Ready < ActiveRecord::Base
  belongs_to :actor

  def selection=(selects)
    self._selection = CSV.generate_line(selects)
  end
  def selection
    CSV.parse_line(_selection)
  end

  def before_filter
    unless message
      self.message = 'Please select'
    end
  end
end
