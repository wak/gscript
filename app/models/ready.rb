# == Schema Information
# Schema version: 20090411123850
#
# Table name: readies
#
#  id         :integer(4)      not null, primary key
#  action     :string(255)
#  gscript    :text
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
