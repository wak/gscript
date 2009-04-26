# == Schema Information
# Schema version: 20090411123850
#
# Table name: items
#
#  id         :integer(4)      not null, primary key
#  actor_id   :integer(4)      not null
#  iname      :string(255)     not null
#  name       :string(255)     default(""), not null
#  ivalue     :integer(4)      default(0), not null
#  svalue     :string(255)     default(""), not null
#  value_type :string(255)     default("i"), not null
#  created_at :datetime
#  updated_at :datetime
#

class Item < ActiveRecord::Base
  belongs_to :actor

  def value
    case value_type
    when 'i'
      return ivalue
    when 's'
      return svalue
    else
      raise "Unknown value type '#{value_type}'"
    end
  end
  def value=(v)
    case value_type
    when 'i'
      self.ivalue = v
    when 's'
      self.ivalue = v
    else
      raise 'No here'
    end
  end
end
