require 'etvnet_seek/core/items_page'
require 'etvnet_seek/core/media_item'

class HomePage < ItemsPage

  def items
    list = []

    document.css("#nav a").each do |item|
      text = item.css("span").text.strip
      href = item['href']
      
      unless href == '/' or href =~ /(person|help|register|press)/
        list << MediaItem.new(text, href)
      end
    end

    list
  end
  
end
