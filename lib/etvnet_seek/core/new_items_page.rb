require 'etvnet_seek/core/items_page'
require 'etvnet_seek/core/browse_media_item'

class NewItemsPage < ItemsPage

  def items
    list = []

    document.css(".gallery ul li a").each do |item|
      text = item.css("img").at(0).attributes['alt'].value.strip
      src = item.css("img").at(0).attributes['src'].value.strip
      href = item['href']

      item = BrowseMediaItem.new(text, href)
      item.image = src
      
      list << item
    end

    list
  end
  
end