# == Schema Information
# Schema version: 20090525100458
#
# Table name: items
#
#  id          :integer(4)      not null, primary key
#  actor_id    :integer(4)      not null
#  iname       :string(255)     not null
#  name        :string(255)     default(""), not null
#  v_int       :integer(4)
#  v_string    :string(255)
#  v_bool      :boolean(1)
#  _value_type :string(255)     not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Item < ActiveRecord::Base
  belongs_to :actor

  def value_type
    _value_type.to_sym
  end
  def value_type=(t)
    self._value_type = t.to_s
  end
  def value
    read_attribute("v_#{_value_type}")
  end
  def value=(v)
    write_attribute("v_#{_value_type}", v)
  end
end
