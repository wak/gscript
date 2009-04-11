class Change < GsActionBase
  def start
    actor(:japan).population *= 3
    actor(:america).fund += 10
  end
end
