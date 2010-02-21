require 'page/get_service_call'
require 'media_info'

class AccessPage < GetServiceCall
  ACCESS_URL = Page::BASE_URL + "/cgi-bin/video/access.fcgi"

  def initialize
    super(ACCESS_URL)
  end

  def request media_file, cookie
    headers = { 'Cookie' => cookie }

    request = Net::HTTP::Post.new(ACCESS_URL, headers)

    request.set_form_data(
      { 'action' => 'start_video', 'bitrate' => '600',
        'media_file'=> media_file, 'replay' => '1', 'skin' => 'JSON'
      }
    )

    request
  end

  def request_media_info media_file, cookie
    response = response_low_level(request(media_file, cookie))

    media_info = response.body

    link = JSON.parse(media_info)["PARAMETERS"]["REDIRECT_URL"]
    session_expired = (JSON.parse(media_info)["PARAMETERS"]["error_session_expire"] == 1)

    MediaInfo.new link, session_expired
  end
end
