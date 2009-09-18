class AutoLog < GScript::GsActionBase
  allow_all
  action_name '神様ログ'
  action_desc '神様ログテスト用に適当に値を変更します．'

  def start
    actor(:mit).fund += 100
    actor(:japan).fund -= 10
    actor(:mit).power += 2
    actor(:japan).population += 30
    write_log(:succeed, :to => [actor(:mit), actor(:japan)])
  end
end
