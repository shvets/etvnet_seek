require 'digest/sha1'
require 'digest/sha2'

module EasyAuth
  # http://techspeak.plainlystated.com/2010/03/drop-dead-simple-authentication-for.html

  # To generate a hashed password (in irb):
  # require 'easy_auth'
  # EasyAuth.hash('my_password') # Put this in AUTHORIZED_USERS

  AUTHORIZED_USERS = {
    'patrick' => "4ded8fa58a5c16298e665b35353555c89b786d8"
  }

  def self.hash_password(password)
    #Digest::SHA256.digest(password)

    Digest::SHA1.hexdigest(password)
  end

  def hash_password(password)
    EasyAuth.hash_password(password)
  end

  def auth_digest(username, password)
    key = "#{username}::#{hash_password(password)}::#{request.env['REMOTE_ADDR']}::#{request.env['HTTP_USER_AGENT']}"
    hash_password key
  end

  def if_auth(username = request.cookies["username"], password = nil)
    if password.nil?
      key = request.cookies["key"]
    else
      key = auth_digest(username, hash_password(password))
    end

    if authorized?(username, key)
      response.set_cookie("username", username)
      response.set_cookie("key", key)
      yield
    else
      @error = "Login failed"
      erb :'/admin/login'
    end
  end

  def authorized?(username, key)
    return false unless AUTHORIZED_USERS.has_key?(username)

    key == auth_digest(username, AUTHORIZED_USERS[username])
  end
end