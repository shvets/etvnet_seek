class CookieHelper
  
  def initialize cookie_file_name
    @cookie_file_name = cookie_file_name
  end

  def load_cookie
    File.exist?(@cookie_file_name) ? read_cookie : nil
  end

  def save_cookie cookie
    return if cookie.nil?
    
    File.open(@cookie_file_name, 'w') { |file| file.puts cookie }
  end

  def delete_cookie
    File.delete @cookie_file_name if File.exist? @cookie_file_name
  end

#  def self.get_expires cookie
#    length = "expires=".length
#
#    #auth = ""
#    expires = ""
#
#    fragment = cookie
#
#    while true do
#      position = fragment.index("expires=")
#
#      break if position == -1
#
#      if fragment[position+length..position+length] != ";"
#        right_position = fragment[position..-1].index(";")
#        #auth = fragment[position+length..position+right_position-1]
#
#        pos1 = position+right_position+1+"expires=".length+1
#        pos2 = fragment[pos1..-1].index(";")
#        expires = fragment[pos1..pos1+pos2-1]
#        break
#      else
#        fragment = fragment[position+length+1..-1]
#      end
#    end
#
#    [auth, expires]
#  end

  def self.get_expires cookie
    p cookie
    length = "expires=".length

    expires = ""

    fragment = cookie

    while true do
      position = fragment.index("expires=")

      break if position == -1

      if fragment[position+length..position+length] != ";"
        right_position = fragment[position..-1].index(";")
        expires = fragment[position+length..position+right_position-1]

        break
      else
        fragment = fragment[position+length+1..-1]
      end
    end

    expires
  end

  def self.get_username cookie
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

  private
  
  def read_cookie
    File.open(@cookie_file_name, 'r') { |file| file.gets }
  end

end
