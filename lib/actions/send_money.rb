class SendMoney < GScript::GsActionBase
  def start
    puts 'Hello'
    @status.change(:continue, :method => :end)
  end
  def end
    puts 'World!'
  end
end
