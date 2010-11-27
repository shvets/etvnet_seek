require 'etvnet_seek/core/group_page'
require 'etvnet_seek/core/group_media_item'

class TopThisWeekPage < GroupPage
  def items
    parent = document.css(".conteiner .coming-soon").at(0).parent
    parent.css("ul.best-list li")

    list = get_typical_items("ul.best-list li", parent)

    node = parent.css("ul.best-list").at(0).next

    unless node.nil?
      link = node.attributes['href'].value
      text = node.children.at(0).content

      list << GroupMediaItem.new(text, link)
    end
  end
end