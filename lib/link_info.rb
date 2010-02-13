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
  
  def self.extract(item, url, cookie)
    media_info = request_media_info(url, item.media_file, cookie)

    link = JSON.parse(media_info)["PARAMETERS"]["REDIRECT_URL"]
    session_expired = (JSON.parse(media_info)["PARAMETERS"]["error_session_expire"] == 1)

    LinkInfo.new(item.underscore_name, item.text, item.media_file, link, session_expired)
  end

  private

  def self.request_media_info url, media_file, cookie
    url = URI.parse(url)
    conn = Net::HTTP.new(url.host, url.port)

    headers = { 'Cookie' => cookie }

    request = Net::HTTP::Post.new(url.request_uri, headers)

    request.set_form_data(
      { 'action' => 'start_video', 'bitrate' => '600',
        'media_file'=> media_file, 'replay' => '1', 'skin' => 'JSON'
      }
    )

    response = conn.request(request)

    response.body
  end

end