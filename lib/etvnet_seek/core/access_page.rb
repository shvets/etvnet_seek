class AccessPage < ServiceCall
  ACCESS_URL = Page::BASE_URL + "/cgi-bin/video/access.fcgi"

  def initialize
    super(ACCESS_URL)
  end

  def request_media_info media_file, cookie
    params = { 'action' => 'start_video', 'bitrate' => '600',
               'media_file'=> media_file, 'replay' => '1', 'skin' => 'JSON' }
    headers = { 'Cookie' => cookie }

    response = post(params, headers)

    MediaInfo.new JSON.parse(response.body)["PARAMETERS"]
  end

end
