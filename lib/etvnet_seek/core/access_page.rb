require 'json'

require 'etvnet_seek/core/page'
require 'etvnet_seek/core/media_info'
require 'etvnet_seek/core/service_call'

class AccessPage < ServiceCall
  ACCESS_URL = Page::BASE_URL + "/watch/"

  def initialize
    super(ACCESS_URL)
  end

  def request_media_info media_file, cookie
    params = { 'bitrate' => '2', 'view' => 'submit'}

#    if true
#      params['high_quality'] = ""
#    end
# &other_server=1
    headers = { 'Cookie' => cookie, 'X-Requested-With' =>	'XMLHttpRequest' }

    response = post(params, headers, url + "#{media_file}/")

    # MediaInfo.new Nokogiri::HTML(response.body).css("ref").at(0).attributes["href"].text

    json = JSON.parse(response.body)

    if response.kind_of? Net::HTTPOK
      MediaInfo.new json["url"]
    else
      raise "Problem getting url: #{response.class.name}: #{json['msg']} "
    end
  end

end
