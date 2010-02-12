class MediaItem
  attr_accessor :text, :link, :first_time, :year, :container, :media_file, :english_name, :how_long

  def initialize(text, link)
    @text = text
    @link = link
  end

  def container?
    not self.container.nil?
  end

  def to_s
    buffer = "#{english_name}(#{media_file}) --- #{text}"

    buffer += " --- #{year}" if not year.nil? and year.size > 0
    buffer += " --- #{how_long}" if not how_long.nil? and how_long.size > 0

    buffer
  end
end

class ChannelMediaItem
  attr_accessor :text, :today_link, :archive_link

  def initialize(text)
    @text = text
  end

  def container?
    false
  end

  def channel today = true
    link = today ? today_link : archive_link
    
    link[link.index("&channel=") + "&channel=".size, link.size-1]
  end

  def to_s
    text
  end
end