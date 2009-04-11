class ReadyThenInput < GScript::GsActionBase
  def start
    @status.change(:ready, :method => :input)
  end
  def input
    text_field(:value, :int,
               :desc => 'Please input number')
    @status.change(:input, :method => :finish)
  end
  def finish
    # nothing
  end
end
