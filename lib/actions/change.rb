class Change < GsActionBase
  def start
    japan.population *= 3
    america.fund += 10
  end
end
