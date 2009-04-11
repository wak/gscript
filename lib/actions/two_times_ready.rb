class TwoTimesReady < GsActionBase
  def start
    @user[:count] = 0
    @status.change(:ready, :method => :count)
  end
  def count
    if (@user[:count] += 1) < 2
      @status.change(:ready, :method => :count)
      _d 'I Changed!'
    end
  end
end
