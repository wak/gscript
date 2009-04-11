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
