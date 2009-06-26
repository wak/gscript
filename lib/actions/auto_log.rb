class AutoLog < GScript::GsActionBase
  allow_all
  action_name '神様ログテスト'

  def start
    actor(:mit).fund += 100
    actor(:japan).fund -= 10
    actor(:mit).power += 2
    actor(:japan).population += 30
  end
end
