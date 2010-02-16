require 'page/post_service_call'

class CookiePage < PostServiceCall
  LOGIN_URL = "#{Page::BASE_URL}/cgi-bin/video/login.fcgi"

  def initialize
    super(LOGIN_URL)
  end

  def retrieve_cookie username, password
    params = "action=login&username=#{username}&pwd=#{password}&skip_notice=&redirect="

    response = response(*params)

    response.response['set-cookie']
  end
end
