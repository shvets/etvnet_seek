class AccessPage < ServiceCall
  ACCESS_URL = Page::BASE_URL + "/watch_new/"

  def initialize
    super(ACCESS_URL)
  end

  def request_media_info media_file, cookie
    params = { 'bitrate' => '2', 'view' => 'submit'}
    headers = { 'Cookie' => cookie }

    @url += "#{media_file}/"
    
    response = post(params, headers)

    MediaInfo.new Nokogiri::HTML(response.body).css("ref").at(0).attributes["href"].text
  end

end
