require 'etvnet_seek/cookie_helper'
require 'etvnet_seek/core/access_page'
require 'etvnet_seek/core/login_page'
require 'etvnet_seek/link_info'

class Accessor
  def initialize cookie_file_name, get_credentials
    @cookie_helper = CookieHelper.new cookie_file_name
    @get_credentials = get_credentials

    @access_page = AccessPage.new
    @login_page = LoginPage.new
  end

  def access item
    cookie = @cookie_helper.load_cookie

    if cookie.nil?
      login(*@get_credentials.call)

      access item
    else
      result = cookie.scan(/sessid=([\d|\w]*);.*_lc=([\d|\w]*);.*/)

      short_cookie = "sessid=#{result[0][0]};_lc=#{result[0][1]}"
      media_info = @access_page.request_media_info(item.link.scan(/.*\/(\d*)\//)[0][0], short_cookie)

      if media_info.session_expired?
        @cookie_helper.delete_cookie

        login(*@get_credentials)

        access item
      else
        LinkInfo.new(item, media_info)
      end
    end
  end

  def login username, password
    cookie = @login_page.login(username, password)

    cookie_helper.save_cookie cookie
  end
end