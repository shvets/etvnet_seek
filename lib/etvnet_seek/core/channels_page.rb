class ChannelsPage < MediaPage
  CHANNELS_URL = BASE_URL + "/tv_channels/"

  def initialize url = CHANNELS_URL
    super(url)
  end

  def catalog?
    @catalog
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

#  def process item, catalog
#    if catalog
#      page = MediaPage.new
#      page.process item.catalog_link
#      #process('media', item.catalog_link)
#    else
#      page = MediaPage.new
#      page.process item.link
##      process('media', tem.link)
#    end
#  end

end
