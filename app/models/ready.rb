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

class Ready < ActiveRecord::Base
end
