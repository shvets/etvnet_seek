class RadioPage < MediaPage
  AUDIO_URL = BASE_URL + "/audio/"

  def initialize url = AUDIO_URL
    super(url)
  end

  def items
    list = []

    document.css("#sidebar #slideshow1 .active a").each do |item|
      text = item.css("img").at(0).attributes["title"].value.strip
      href = item['href']

      list << MediaItem.new(text, href)
    end

    list
  end
end