class GroupMediaItem < MediaItem
  attr_reader :channel

  def initialize(text, link, channel)
    super(text, link)

    @channel = channel
  end

  def to_s
    "#{text} --- #{channel} --- #{link}"
  end

end
