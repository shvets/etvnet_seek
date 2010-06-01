class NewItemsPage < BasePage

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