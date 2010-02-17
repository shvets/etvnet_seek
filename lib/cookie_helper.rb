require 'net/http'
require 'uri'

require 'page/cookie_page'

class CookieHelper

  #attr_reader :cookie
  
  def initialize cookie_file_name, &block
    @cookie_file_name = cookie_file_name
    @request_credentials = block

    @cookie = get_cookie
  end

  def cookie
    @cookie ||= get_cookie
  end

  def renew_cookie
    delete_cookie
    @cookie = nil
    #@cookie = retrieve_cookie
  end

  private

  def get_cookie
    if File.exist? @cookie_file_name
      cookie = read_cookie
    else
      username, password = @request_credentials.call

      cookie = retrieve_cookie username, password

      write_cookie cookie
   end

    cookie
  end

  def delete_cookie
    File.delete @cookie_file_name if File.exist? @cookie_file_name
  end
  
  def read_cookie
    File.open(@cookie_file_name, 'r') { |file| file.gets }
  end

  def write_cookie cookie
    File.open(@cookie_file_name, 'w') { |file| file.puts cookie }
  end

  def retrieve_cookie username, password
    page = CookiePage.new

    cookie = page.retrieve_cookie(username, password)
    
    cleanup_cookie(cookie)
  end
  
  def cleanup_cookie cookie
    auth, expires = get_auth_and_expires(cookie)
    username = get_username(cookie)
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

  def get_auth_and_expires cookie
    length = "auth=".length

    auth = ""
    expires = ""

    fragment = cookie

    while true do
      position = fragment.index("auth=")

      break if position == -1

      if fragment[position+length..position+length] != ";"
        right_position = fragment[position..-1].index(";")
        auth = fragment[position+length..position+right_position-1]

        pos1 = position+right_position+1+"expires=".length+1
        pos2 = fragment[pos1..-1].index(";")
        expires = fragment[pos1..pos1+pos2-1]
        break
      else
        fragment = fragment[position+length+1..-1]
      end
    end

    [auth, expires]
  end

  def get_username cookie
    length = "username=".length

    username = ""

    fragment = cookie

    while true do
      position = fragment.index("username=")

      break if position == -1

      if fragment[position+length..position+length] != ";"
        right_position = fragment[position..-1].index(";")
        username = fragment[position+length..position+right_position-1]

        break
      else
        fragment = fragment[position+length+1..-1]
      end
    end

    username
  end
end
