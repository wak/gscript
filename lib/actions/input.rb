class Input < GScript::GsActionBase
  allow_all

  def start
    select_field(:actor, :actor,
                 :selected => @current,
                 :list => @actors,
                 :desc => 'Please select your actor')
    select_field(:ivalue, :int,
                 :list => (1..10).to_a,
                 :desc => 'Please select 5') {|n|
      n == 5
    }
    text_field(:value, :int,
               :desc => 'Please input number')
    select_field(:item, :item,
                 :list => [actor(:japan).fund],
                 :desc => 'Please select item')

    @status.change(:input, :method => :nothing)
  end
  def nothing
    # nothing
  end
end
