class ChannelsPage < MediaPage
  CHANNELS_URL = BASE_URL + "/tv_channels/"

  def initialize url = CHANNELS_URL
    super(url)
  end

  def items
    list = []

    document.css(".table-all-kanali tr").each do |item|
      links = item.css("td a")

      text = item.children.at(0).text.strip

      if text.size > 0
        link = nil
        catalog_link = nil

        if links.size > 0
          href = links[0]
          catalog_href = links[1]

          link = href.attributes['href'].value unless href.nil?

          catalog_link = catalog_href.attributes['href'].value unless catalog_href.nil?
        end

        list << ChannelMediaItem.new(text, link, catalog_link) unless link.nil?
      end
    end

    list
  end

end
