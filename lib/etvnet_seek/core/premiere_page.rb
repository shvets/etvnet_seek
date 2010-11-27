class PremierePage < GroupPage
  def items
    get_typical_items("ul.recomendation-list li")
  end
end