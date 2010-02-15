require 'json'

class MediaInfo
  def initialize link, session_expired
    @link = link
    @session_expired = session_expired
  end

  def resolved?
    not @link.nil? and not @link.strip.size == 0
  end

  def link
    @link
  end

  def session_expired?
    @session_expired
  end

end