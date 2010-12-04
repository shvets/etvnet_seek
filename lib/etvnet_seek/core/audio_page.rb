require 'etvnet_seek/core/items_page'
require 'etvnet_seek/core/media_item'

class AudioPage < ItemsPage
  AUDIO_URL = BASE_URL + "/audio/"

  def initialize url = AUDIO_URL
    super(url)
  end

  def items
    list = []

    document.css("#nav a").each do |item|
      text = item.css("span").text.strip
      href = item['href']

      unless href == '/' or href =~ /(press|register|persons)/
        list << MediaItem.new(text, href)
      end
    end

    list
  end

end
