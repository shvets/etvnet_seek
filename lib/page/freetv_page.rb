require 'page/page'
require 'browse_media_item'

class FreetvPage < MediaPage
  FREETV_URL = BASE_URL + "/freeTV.html"

  def initialize
    super(FREETV_URL)
  end

 def items
    list = []

    document.css("table tr").each do |item|
      node = item.css("td img")
      if node.size > 0
        text = node.at(0).parent.css("a")
        unless text.to_s.size == 0
          link = node.at(0).parent.css("a")
          text = link.at(0).text.gsub(/\s\s+/, ' ')
          rating_image = node.at(0).attributes['src']
          image = link.at(0).parent.parent.previous.css("td img").at(0).attributes['src'].value.strip
          
          href = link.at(0).attributes['href'].value.strip

          record = BrowseMediaItem.new(text, href)
          record.rating_image = rating_image
          record.image = image

          list << record
        end
      end
    end

    list
  end
end
