require 'nokogiri'
require 'open-uri'
require 'cgi'
require 'json'

require 'items_helper'
require 'user_selection'
require 'search_result'

class UrlSeeker
  include ItemsHelper

  BASE_URL     = "http://www.etvnet.ca"
  SEARCH_URL   = BASE_URL + "/cgi-bin/video/eitv_browse.fcgi?action=search"
  ACCESS_URL   = BASE_URL + "/cgi-bin/video/access.fcgi"
  LOGIN_URL    = BASE_URL + "/cgi-bin/video/login.fcgi"
  BROWSE_URL   = BASE_URL + "/cgi-bin/video/eitv_browse.fcgi"
  CHANNELS_URL = BROWSE_URL + "?action=channels"
  TODAY_URL    = BROWSE_URL + "?action=today"

  def get_items mode, *params
    case mode
      when 'search' then
        search_items *params
      when 'main' then
        main_items
      when 'channels' then
        channel_items
      when 'best_ten' then
        best_ten_items
      when 'popular' then
        popular_items
      when 'we_recommend' then
        we_recommend_items
      when 'today' then
        today_items *params
      when 'archive' then
        archive_items *params
      when 'announces' then
        get_menu_items "#{BASE_URL}#{params[0]}"
      when 'freetv' then
        get_freetv_items "#{BASE_URL}#{params[0]}"
      when 'category' then
        get_menu_items "#{BASE_URL}#{params[0]}"
      else
        []
    end
  end

  def display_items items
    if items.size == 0
      puts "Empty search result."
    else
      items.each_with_index do |item1, index1|
        if item1.container?
          puts "#{index1+1}. #{item1.text}"

          item1.container.each_with_index do |item2, index2|
            puts "  #{index1+1}.#{index2+1}. #{item2}"
          end
        else
          puts "#{index1+1}. #{item1}"
        end
      end
    end
  end

  def grab_media items, title_number, cookie
    item = title_number.one_level? ? items[title_number.index1] :
                                     items[title_number.index1].container[title_number.index2]
    media = request_media_info(item.media_file, cookie)

    SearchResult.new(mms_link(media), item.english_name)
  end

  def mms_link media_info
    JSON.parse(media_info)["PARAMETERS"]["REDIRECT_URL"]
  end

  def session_expired? media_info
    JSON.parse(media_info)["PARAMETERS"]["error_session_expire"] == 1
  end

  private

  def search_items keywords, order_direction='-'
    search_url = "#{SEARCH_URL}&keywords=#{CGI.escape(keywords)}&order_direction=#{order_direction}"

    get_menu_items search_url
  end

  def channel_items
    get_channel_items CHANNELS_URL
  end

  def main_items
    get_main_menu_items BASE_URL
  end

  def best_ten_items
    get_best_ten_items BASE_URL
  end

  def popular_items
    get_popular_items BASE_URL
  end

  def we_recommend_items
    get_we_recommend_items BASE_URL
  end

  def today_items channel
    get_menu_items "#{TODAY_URL}&channel=#{channel}"
  end

  def archive_items channel
    get_menu_items "#{BROWSE_URL}?channel=#{channel}"
  end

  def request_media_info media_file, cookie
    url = URI.parse(ACCESS_URL)
    conn = Net::HTTP.new(url.host, url.port)
    
    headers = { 'Cookie' => cookie }
  
    request = Net::HTTP::Post.new(url.request_uri, headers)
  
    request.set_form_data(
      { 'action' => 'start_video', 'bitrate' => '600',
        'media_file'=> media_file, 'replay' => '1', 'skin' => 'JSON'
      }
    )
  
    response = conn.request(request)
  
    response.body
  end

end
