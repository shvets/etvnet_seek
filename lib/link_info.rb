class LinkInfo
  attr_reader :name, :text, :media_file, :link

  def initialize(name = '', text = '', media_file = '', link = '', session_expired = true)
    @name = name
    @text = text
    @media_file = media_file
    @link = link
    @session_expired = session_expired
  end

  def resolved?
    not @link.nil? and not @link.strip.size == 0
  end

  def session_expired?
    @session_expired
  end

end