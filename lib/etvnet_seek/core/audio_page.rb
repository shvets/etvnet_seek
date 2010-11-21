class AudioPage < MediaPage
  AUDIO_URL = BASE_URL + "/audio/"

  def initialize url = AUDIO_URL
    super(url)
  end

  def items
    list = []

    document.css("#nav a").each do |item|
      text = item.css("span").text.strip
      href = item['href']

      unless href == '/' or href =~ /(press|register)/
        list << MediaItem.new(text, href)
      end
    end

    list
  end

end
