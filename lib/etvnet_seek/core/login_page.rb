require 'stringio'

require 'etvnet_seek/core/service_call'

class LoginPage < ServiceCall
  LOGIN_URL = "#{Page::BASE_URL}/login/"

  def initialize
    super(LOGIN_URL)
  end

  def login username, password
    headers = { "Content-Type" => "application/x-www-form-urlencoded" }

    response = post({ 'action' => '/login/', 'username' => username, 'password'=> password }, headers)

    cookie = response.response['set-cookie']

    p cookie

#    unless cookie.nil?
#      cookie = cleanup_cookie(cookie)
#    end

    cookie
    #[0..cookie.index(";")-1]
  end

#  private
#
#  def cleanup_cookie cookie
#    auth, expires = CookieHelper.get_auth_and_expires(cookie)
#    username = CookieHelper.get_username(cookie)
#    path = "/"
#    domain = ".etvnet.com"
#
#    cookies_text = <<-TEXT
#      auth=#{auth}; expires=#{expires}; path=#{path}; domain=#{domain}
#      username=#{username}; expires=#{expires}; path=#{path}; domain=#{domain}
#    TEXT
#
#    new_cookie = ""
#
#    StringIO.new(cookies_text).each_line do |line|
#      new_cookie = new_cookie + line.strip + "; "
#    end
#
#    new_cookie
#  end


  def process item, cookie_helper
    cookie = login(*get_credentials)

    cookie_helper.save_cookie cookie

#    process("access", item)

    page = AccessPage.new
    page.process item, cookie_helper
  end

  def get_credentials
    username = ask("Enter username :  ")
    password = ask("Enter password : ") { |q| q.echo = '*' }

    [username, password]
  end
end
