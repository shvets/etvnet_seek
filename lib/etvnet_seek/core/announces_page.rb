class AnnouncesPage < MediaPage
  ANNOUNCES_URL = BASE_URL + "/announces/"

  def initialize()
    super(ANNOUNCES_URL)
  end

  def category_breadcrumbs
    []
  end

  def items
    list = []

    document.css(".gallery ul li").each do |item|
      text = item.css("a img").at(0).attributes['alt'].value.strip
      link = item.css("a").at(1)

      unless link.nil?
        href = link.attributes['href'].value

        record = BrowseMediaItem.new(text, href)

        list << record
      end
    end

    list
  end
end
