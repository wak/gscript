class TwoTimesReady < GScript::GsActionBase
  allow_category :country

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
