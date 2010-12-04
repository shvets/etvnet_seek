require 'etvnet_seek/core/page'
require 'etvnet_seek/core/items_page'
require 'etvnet_seek/core/channel_media_item'

class ChannelsPage < ItemsPage
  CHANNELS_URL = Page::BASE_URL + "/tv_channels/"

  def initialize url = CHANNELS_URL
    super(url)
  end

  def items
    list = []

    document.css("#table-onecolumn-kanali tr").each do |item|
      links = item.css("td a")

      text = item.children.at(0).text.strip

      href = links[0]
      catalog_href = links[1]

      link = href.attributes['href'].value

      catalog_link = catalog_href.attributes['href'].value

      list << ChannelMediaItem.new(text, link, catalog_link)
    end

    list
  end

end
