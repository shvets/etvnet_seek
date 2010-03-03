class ChannelsPage < MediaPage
  BROWSE_URL   = BASE_URL + "/cgi-bin/video/eitv_browse.fcgi"
  CHANNELS_URL = BROWSE_URL + "?action=channels"

  def initialize url = CHANNELS_URL
    super(url)
  end

  def items
    list = []

    document.css("table table table.rounded_white table tr").each_with_index do |item, index|
      links = item.css("table tr td a")

      text = item.children.at(0).text.strip

      if text.size > 0
        link = nil
        archive_link = nil

        if links.size > 0
          href = links[0]
          archive_href = links[1]

          link = href.attributes['href'].value unless href.nil?

          archive_link = archive_href.attributes['href'].value unless archive_href.nil?
        end

        list << ChannelMediaItem.new(text, link, archive_link) unless link.nil?
      end
    end

    list
  end

end
