class SimpleAction < GScript::GsAction::SimpleAction
	allow_all
  action_name 'アクションフレームワーク'
  action_desc <<-EOS
    特定パターンのアクションを生成するためのフレームワークを作成可能か
    試してみる．フォーム生成部は，set_inputなどを作成する労力に見合わな
    い気がするため，普通に入力．もっと注意深く値を操作し，適切にログを
    書けば十分に使えると思われる．
  EOS

	def do_input
    select_field(:target, :actor,
                 :selected => @current,
                 :list => @actors,
                 :message => 'Please select target actor')
    select_field(:level, :int,
                 :list => [1,5,99],
                 :message => 'Please number (valid is 1 or 5)')
	end
	def setup
		# execute
		set_apply(:target, :level, {
								1 => [[:fund, -100], [:power, -150]],
								5 => [[:fund, -500], [:power, -250]]
							})
		set_apply(nil, :level, {
								1 => [[:fund, 100], [:power, 150]],
								5 => [[:fund, 500], [:power, 250]]
							})

	end
end
