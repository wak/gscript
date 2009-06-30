class SendMoney < GScript::GsActionBase
  allow_all
  action_name '送金サンプル'
  action_desc '送金します．'

  def start
    select_field(:to, :actor,
                 :list => actors,
                 :name => 'Target actor',
                 :message => 'Select target actor')
    text_field(:much, :int,
               :min => 1,
               :max => @current.fund,
               :name => 'Amount',
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
#    @status.log.active_actor = @current
#    @status.log.passive_actor = input(:to)

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
    @user[:to].fund += @user[:much]
    message = sprintf("%s => %s [$%d]",
                      @user[:from].name, @user[:to].name, @user[:much])
#    @user[:to].log(message, :type => :succeed)
#    @user[:from].log(message, :type => :succeed)
  end
  def cancel
    @user[:from].fund += @user[:much]
    message = sprintf("CANCEL %s => %s [$%d]",
                      @user[:from].name, @user[:to].name, @user[:much])
#    @user[:to].log(message, :type => :cancel)
#    @user[:from].log(message, :type => :cancel)

    @status.change(:cancel)
  end
end
