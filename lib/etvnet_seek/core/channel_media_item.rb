class ChannelMediaItem < MediaItem
  attr_reader :catalog_link

  def initialize(text, link, catalog_link)
    super(text, link)

    @catalog_link = catalog_link
  end

  def channel
    link.scan(/\/(\w*)/)[2]
  end

  def to_s
    super + " (#{channel})"
  end
end
