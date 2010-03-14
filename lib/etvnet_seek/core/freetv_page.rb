class FreetvPage < MediaPage
  FREETV_URL = BASE_URL + "/freeTV/"

  def initialize
    super(FREETV_URL)
  end

  def category_breadcrumbs
    []
  end

  def items
    list = []

    document.css(".gallery ul li").each do |item|
      text = item.css("a span").text.strip
      link = item.css("a").at(0)
      image = item.css("a img").at(0).attributes['src'].value.strip
      rating_image = item.css("a em img").at(0).attributes['src'].value.strip

      unless link.nil?
        href = link.attributes['href'].value

        record = BrowseMediaItem.new(text, href)

        record.image = image
        record.rating_image = rating_image

        list << record
      end
    end

    list
  end
end
