# == Schema Information
# Schema version: 20090525100458
#
# Table name: g_files
#
#  id           :integer(4)      not null, primary key
#  actor_id     :integer(4)      not null
#  size         :integer(4)      not null
#  content_type :string(255)     not null
#  filename     :string(255)     default("no_name"), not null
#  db_file_id   :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

class GFile < ActiveRecord::Base
  belongs_to :actor

  has_attachment(:size => (1.bytes .. 1.megabytes),
                 :storage => :file_system,
                 #:storage => :db_file,
                 :path_prefix => 'uploaded')

  alias :_actor= :actor=
  def actor=(actor)
    case actor
    when Actor
      _actor = actor
    when GScript::GsActor
      _actor = actor._actor
    end
  end
end
