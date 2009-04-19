class Continue < GScript::GsActionBase
  allow_all

  def start
    change(:continue, :method => :continue)
  end
  def continue
    unless @ready == :finish
      change(:ready,
             :method => :continue,
             :actor => @current,
             :selection => [:continue, 'CONTINUE',
                            :finish, 'FINISH'])
    end
  end
end
