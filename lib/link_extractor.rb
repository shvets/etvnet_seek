class LinkExtractor
  attr_reader :link

  def initialize(item)
    @item = item
  end

  def request(url, cookie)
    media_info = request_media_info(url, @item.media_file, cookie)

    @link = JSON.parse(media_info)["PARAMETERS"]["REDIRECT_URL"]
    @session_expired = (JSON.parse(media_info)["PARAMETERS"]["error_session_expire"] == 1)

    self
  end

  def name
    @item.english_name
  end

  def resolved?
    not @link.nil?
  end

  def session_expired?
    @session_expired
  end

  private

  def request_media_info url, media_file, cookie
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