# == Schema Information
# Schema version: 20090525100458
#
# Table name: action_log_changes
#
#  id            :integer(4)      not null, primary key
#  action_log_id :integer(4)      not null
#  item_id       :integer(4)      not null
#  actor_id      :integer(4)      not null
#  _value_type   :string(255)     not null
#  vb_int        :integer(4)
#  va_int        :integer(4)
#  vb_string     :string(255)
#  va_string     :string(255)
#  vb_bool       :boolean(1)
#  va_bool       :boolean(1)
#  created_at    :datetime
#  updated_at    :datetime
#

class ActionLogChange < ActiveRecord::Base
  belongs_to :action_log
  belongs_to :item
  belongs_to :actor

  def value_type
    _value_type.to_sym
  end
  def value_type=(t)
    self._value_type = t.to_s
  end
  def before_value=(v)
    write_attribute("vb_#{_value_type}", v)
  end
  def after_value=(v)
    write_attribute("va_#{_value_type}", v)
  end
  def before_value
    read_attribute("vb_#{_value_type}")
  end
  def after_value
    read_attribute("va_#{_value_type}")
  end
end
