require 'page/page'
require 'browse_media_item'

class AnnouncesPage < MediaPage
  ANNOUNCES_URL = BASE_URL + "/announces.html"

  def initialize()
    super(ANNOUNCES_URL)
  end

  def category_breadcrumbs
    []
  end

  def items
    list = []

    document.css("table tr td div").each do |item|
      unless item.css("a").at(0).nil?
        image = item.css("img").at(0).attributes['src'].value.strip

        unless image == 'images/banner_announces.jpg'
          text = item.css("img").at(0).attributes['alt'].value.strip
          href = item.css("a").at(0).attributes['href'].value
          image = item.css("img").at(0).attributes['src'].value.strip

          record = BrowseMediaItem.new(text, href)
          record.image = image

          list << record
        end
      end
    end

    list
  end
end
