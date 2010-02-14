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

    media_info = response.body

    link = JSON.parse(media_info)["PARAMETERS"]["REDIRECT_URL"]
    session_expired = (JSON.parse(media_info)["PARAMETERS"]["error_session_expire"] == 1)

    MediaInfo.new link, session_expired
  end

end