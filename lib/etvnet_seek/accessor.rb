require 'etvnet_seek/cookie_helper'
require 'etvnet_seek/core/access_page'
require 'etvnet_seek/core/login_page'
require 'etvnet_seek/link_info'

class Accessor
  def initialize cookie_file_name, credentials_collector
    @cookie_helper = CookieHelper.new cookie_file_name
    @credentials_collector = credentials_collector

    @access_page = AccessPage.new
    @login_page = LoginPage.new
  end

  def access item, *params
    @try_again = false

    cookie = @cookie_helper.load_cookie

    if cookie.nil?
      username, password = *@credentials_collector.call(*params)

      @try_again = login(username, password)

      nil
    else
      cookie.gsub!("\"", "\"\"")

      result1 = cookie.scan(/.*sessid=([\d|\w]*);.*/)      
      result2 = cookie.scan(/.*_lc=([\d|\w]*);.*/)

      short_cookie = "sessid=#{result1[0][0]};_lc=#{result2[0][0]}"
      media_info = @access_page.request_media_info(item.link.scan(/.*\/(\d*)\//)[0][0], short_cookie)

	    #AWSUSER_ID=awsuser_id1290276702916r5408;
      #_lc=821f084d0a9106c1d7093f9d487e6c95c4a88599;
      #_ct="IZb4DpULgzkOZBFcc7LR5uNoQanMuRFjOcZw6oBAOuvlSFcov4PK3h3fhCFgRB+H02dmpKzsegk8\012wh8Mugw2URKnLW8nIbPJqcG6KxB2ixai8ePAoJMCp6mqvAoD5Bfm9uTLrCadLLwWEfZMi8q54MhN\01203Uo";
      #sessid=b1798033c89a70f43c040924af721896

      if media_info.session_expired?
        @cookie_helper.delete_cookie

        username, password = *@credentials_collector.call(*params)

        @try_again = login(username, password)

        nil
      else
        LinkInfo.new(item, media_info)
      end
    end
  end

  def try_again?
    @try_again
  end
  
  def login username, password
    cookie = @login_page.login(username, password)

    @cookie_helper.save_cookie cookie

    cookie.nil?
  end

end