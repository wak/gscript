class TwoTimesReady < GScript::GsAction::GenericAction
  allow_category :country
  action_name 'TwoTimesReady'
  action_desc '2回承認すると終了します．'

  def start
    @user[:count] = 0
    count
  end
  def count
    current = @user[:count]
    @user[:count] += 1
    if current < 2
      change(:ready,
             :method => :count,
             :message => "Last #{2-current}",
             :actor => @current,
             :selection => [:count, 'Click me!'])
    end
  end
end
