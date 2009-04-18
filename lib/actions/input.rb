class Input < GScript::GsActionBase
  allow_all

  def start
    select_field(:actor, :actor,
                 :selected => @current,
                 :list => @actors,
                 :message => 'Please select your actor')
    select_field(:ivalue, :int,
                 :list => (1..10).to_a,
                 :message => 'Please select 5') {|n|
      '5ではありません．' unless n == 5
    }
    text_field(:value, :int,
               :list => [0, 3],
               :error => {:list => '0または3を入力してください'},
               :message => 'Please input 0 or 3')
    select_field(:item, :item,
                 :list => [actor(:japan).fund],
                 :blank => true,
                 :message => 'Please select item')

    @status.change(:input, :method => :nothing)
  end
  def nothing
    # nothing
  end
end
