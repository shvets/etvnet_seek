require 'page/post_service_call'
require 'page/page'

class LoginPage < ServiceCall
  LOGIN_URL = "#{Page::BASE_URL}/cgi-bin/video/login.fcgi"

  def initialize
    super(LOGIN_URL)
  end

  def login username, password
    params = "action=login&username=#{username}&pwd=#{password}&skip_notice=&redirect="

    response = post(*params)

    cookie = response.response['set-cookie']

    unless cookie.nil?
      cookie = cleanup_cookie(cookie)
    end

    cookie
  end

  private

  def cleanup_cookie cookie
    auth, expires = CookieHelper.get_auth_and_expires(cookie)
    username = CookieHelper.get_username(cookie)
    path = "/"
    domain = ".etvnet.ca"

    cookies_text = <<-TEXT
      auth=#{auth}; expires=#{expires}; path=#{path}; domain=#{domain}
      username=#{username}; expires=#{expires}; path=#{path}; domain=#{domain}
    TEXT

    new_cookie = ""
    require 'stringio'
    StringIO.new(cookies_text).each_line do |line|
      new_cookie = new_cookie + line.strip + "; "
    end

    new_cookie
  end

end
