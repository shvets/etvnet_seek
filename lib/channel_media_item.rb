require 'media_item'

class ChannelMediaItem < MediaItem
  attr_reader :archive_link

  def initialize(text, link, archive_link)
    super(text, link)

    @archive_link = archive_link
  end

  def channel
    link[link.index("channel=") + "channel=".size, link.size-1]
  end
end
