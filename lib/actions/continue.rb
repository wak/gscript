class Continue < GScript::GsActionBase
  allow_all
  action_name 'Readyループ'
  action_desc 'Ready状態を繰り返します．'

  def start
      @user[:times] = 0
    change(:continue, :method => :continue)
  end
  def continue
    unless @ready == :finish
      @user[:times] += 1

      change(:ready,
             :method => :continue,
             :actor => @current,
             :message => "Are you loop? (#{@user[:times]-1} times)",
             :selection => [:continue, 'YES',
                            :finish, 'NO'])
    end
  end
end
