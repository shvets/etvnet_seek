class MediaItem
  attr_accessor :text, :link

  def initialize(text, link)
    @text = text
    @link = link
  end

  def container?
    false
  end

  def to_s
    text
  end  
end

class ChannelMediaItem < MediaItem
  attr_accessor :archive_link

  def initialize(text)
    super(text, nil)
  end

  def channel
    link[link.index("channel=") + "channel=".size, link.size-1]
  end
end

class BrowseMediaItem < MediaItem
  attr_accessor :container, :showtime, :starts, :rating, :info_link, :year, :duration

  def initialize(text, link)
    super(text, link)

    @underscore_name = extract_underscore_name
    @media_file = extract_media_file
  end

  def container?
    not self.container.nil?
  end

  def underscore_name
    container? ? 'Folder'  : @underscore_name
  end

  def media_file
    @media_file
  end

  def to_s
    buffer = "#{underscore_name}"
    buffer += " (#{media_file})" if not media_file.nil? and media_file.size > 0
    buffer += ": #{text}"

    buffer += " --- #{year}" if not year.nil? and year.size > 0
    buffer += " --- #{duration}" if not duration.nil? and duration.size > 0

    buffer
  end

  private

  def extract_underscore_name
    result = link.match(/(\w*)\/(\w*)\/(\w*)\/([\w|-]*)/)

    return nil if result.nil?

    (result.size > 3) ? result[4] : ""
  end

  def extract_media_file
    result = link.match(/(\w*)\/(\w*)\/(\w*)\/([\w|-]*)/)

    (not result.nil? and result.size > 2) ? result[3] : ""
  end
end
