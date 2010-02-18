class SendMoney < GScript::GsAction::GenericAction
  allow_all
  action_name '送金アクション'
  action_desc '送金アクションのサンプルです．'

  def start
    select_field(:to, :actor,
                 :list => actors_ex,
                 :message => 'Select target actor')
    text_field(:much, :int,
               :min => 1,
               :max => @current.fund,
               :message => 'How much?',
               :error => {
                 :min => 'Should positive number.',
                 :max => 'Your fund too small.'
               })
    @status.change(:input, :method => :ready)
  end
  def ready
    @user[:from] = @current
    @user[:to] = input(:to)
    @user[:much] = input(:much)

    @current.fund -= input(:much)
    @status.change(:ready,
                   :actor => input(:to),
                   :method => :switch,
                   :selection => [:accepted, 'Yes', :refused, 'No'],
                   :message => "#{@current.name} send you $#{input(:much)}.")
  end
  def switch
    case @ready
    when :accepted
      @status.change(:continue, :method => :execute)
    when :refused
      @status.change(:continue, :method => :cancel)
    else
      raise 'No here.'
    end
  end
  def execute
    from, to, much = @user[:from], @user[:to], @user[:much]

    to.fund += much
    write_log(:succeed,
              :to => [from, to],
              :args => { :from => from, :to => to, :much => much })
  end
  def cancel
    from, to, much = @user[:from], @user[:to], @user[:much]
    from.fund += much
    write_log(:canceled,
              :to => [from, to],
              :args => { :from => from, :to => to, :much => much })
    @status.change(:cancel)
  end
end
