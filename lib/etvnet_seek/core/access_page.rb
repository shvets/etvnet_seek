require 'json'

require 'etvnet_seek/core/media_info'
require 'etvnet_seek/core/service_call'
require 'etvnet_seek/core/login_page'

class AccessPage < ServiceCall
  ACCESS_URL = Page::BASE_URL + "/watch/"

  def initialize cookie_helper
    super(ACCESS_URL)
    @cookie_helper = cookie_helper
  end

  def request_media_info media_file, cookie
    params = { 'bitrate' => '2', 'view' => 'submit'}

    headers = { 'Cookie' => cookie, 'X-Requested-With' =>	'XMLHttpRequest' }

    @url += "#{media_file}/"
    
    response = post(params, headers)

    # MediaInfo.new Nokogiri::HTML(response.body).css("ref").at(0).attributes["href"].text

    json = JSON.parse(response.body)
    MediaInfo.new json["url"]
  end

  def process item
    cookie = @cookie_helper.load_cookie

    if cookie.nil?
      #process("login", item)
      page = LoginPage.new
      page.process item
    else
      #expires = CookieHelper.get_expires(cookie)
      #cookie_expire_date =  DateTime.strptime(expires, "%A, %d-%b-%Y %H:%M:%S %Z")

#      if cookie_expire_date < DateTime.now # cookie expired?
#        @cookie_helper.delete_cookie

#        process("login", item)
#      else
      #media_info = page.request_media_info(item.media_file, cookie)

      result = cookie.scan(/sessid=([\d|\w]*);.*_lc=([\d|\w]*);.*/)

      short_cookie = "sessid=#{result[0][0]};_lc=#{result[0][1]}"
      media_info = request_media_info(item.link.scan(/.*\/(\d*)\//)[0][0], short_cookie)

      if media_info.session_expired?
        @cookie_helper.delete_cookie

        #process("login", item)
        page = LoginPage.new
        page.process item
      else
        LinkInfo.new(item, media_info)
      end
      #     end
    end
  end

end
