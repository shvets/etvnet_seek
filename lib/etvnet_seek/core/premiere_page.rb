require 'etvnet_seek/core/group_page'

class PremierePage < GroupPage
  def items
    get_typical_items("ul.recomendation-list li")
  end
end