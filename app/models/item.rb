# == Schema Information
# Schema version: 20090110064135
#
# Table name: items
#
#  id         :integer(4)      not null, primary key
#  actor_id   :integer(4)      not null
#  iname      :string(255)     default(""), not null
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
    when 'i': return ivalue
    when 's': return svalue
    else
      raise "Unknown value type '#{value_type}'"
    end
  end
  def value=(v)
    case v
    when String
      self.svalue = v
      self.value_type = 's'
    when Fixnum, Bignum
      self.ivalue = v
      self.value_type = 'i'
    end
  end
end
