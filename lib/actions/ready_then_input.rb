class ReadyThenInput < GScript::GsAction::GenericAction
  def start
    @status.change(:ready, :method => :input)
  end
  def input
    text_field(:value, :int,
               :message => 'Please input number')
    @status.change(:input, :method => :finish)
  end
  def finish
    # nothing
  end
end
