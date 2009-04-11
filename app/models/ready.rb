# == Schema Information
# Schema version: 20090110064135
#
# Table name: readies
#
#  id         :integer(4)      not null, primary key
#  gscript    :text
#  created_at :datetime
#  updated_at :datetime
#

class Ready < ActiveRecord::Base
end
