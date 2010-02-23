require 'page/service_call'
require 'media_info'

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

    media_info = response.body

    link = JSON.parse(media_info)["PARAMETERS"]["REDIRECT_URL"]
    session_expired = (JSON.parse(media_info)["PARAMETERS"]["error_session_expire"] == 1)

    MediaInfo.new link, session_expired
  end

end
