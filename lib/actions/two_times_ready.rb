class TwoTimesReady < GScript::GsActionBase
  allow_category :country

  def start
    @user[:count] = 0
    change(:ready,
           :method => :count,
           :actor => @current,
           :selection => [:hoge, 'HOGE'])
  end
  def count
    if (@user[:count] += 1) < 2
      change(:ready,
             :method => :count,
             :actor => @current,
             :selection => [:hoge, 'HOGE',
                            :piyo, 'PIYO'])
    end
  end
end
