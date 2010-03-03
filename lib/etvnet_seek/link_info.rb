class LinkInfo
  attr_reader :media_item, :media_info

  def initialize(media_item, media_info)
    @media_item = media_item
    @media_info = media_info
  end

  def resolved?
    not @media_info.link.nil? and not @media_info.link.strip.size == 0
  end

  def session_expired?
    @media_info.session_expired
  end

  def text
    media_item.text
  end

  def name
    media_item.underscore_name
  end

  def media_file
    media_item.media_file
  end

  def link
    media_info.link
  end

  def rtsp_link
    media_info.rtsp_link
  end

end