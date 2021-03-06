class File < GScript::GsAction::GenericAction
  allow_actor :japan, :america
  action_name 'ファイル操作'
  action_desc 'ファイルのアップロードとダウンロード．'

  def start
    clear_fields
    select_field(:mode, :symbol,
                 :list => [:upload, :download],
                 :message => 'Select mode')

    select_field(:actor, :actor,
                 :list => @actors,
                 :message => 'Select actor')
    file_field(:file,
               :blank => true,
               :message => 'Input file') {|file|
      (input(:mode) == :upload) ? !!file : true
    }
    @status.change(:input, :method => :switch)
  end
  def switch
    @status.change(:continue, :method => input(:mode))
  end
  def upload
    file = input(:file)
    actor = input(:actor)
    actor.files << file
  end
  def download
    actor = input(:actor)
    file = actor.files.first
    if file
      @status.change(:send_file, :file => file)
    else
      @status.change(:continue, :method => :start)
    end
  end
end
