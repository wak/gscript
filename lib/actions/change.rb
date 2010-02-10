class Change < GScript::GsAction::GenericAction
	allow_all

  def start
		actor(:japan).fund += 100
		actor(:japan).fund -= 100
  end
end
