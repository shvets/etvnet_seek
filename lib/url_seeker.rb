require 'nokogiri'
require 'open-uri'
require 'cgi'
require 'json'

require 'items_helper'
require 'title_number'

class UrlSeeker
  include ItemsHelper

  BASE_URL = "http://www.etvnet.ca"
  SEARCH_URL = BASE_URL + "/cgi-bin/video/eitv_browse.fcgi?action=search"
  ACCESS_URL = BASE_URL + "/cgi-bin/video/access.fcgi"
  LOGIN_URL =  BASE_URL + "/cgi-bin/video/login.fcgi"

  def search_items keywords, order_direction='-'
    search_url = "#{SEARCH_URL}&keywords=#{CGI.escape(keywords)}&order_direction=#{order_direction}"

    get_search_menu_items search_url
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

  def display_items items
    if items.size == 0
      puts "Empty search result."
    else
      items.each_with_index do |item1, index1|

        if item1.container?
          puts "#{index1+1}. #{item1[:text]}"

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
    link = title_number.one_level? ? items[title_number.index1].link : items[index1].container[index2].link

    grab_media_info link, cookie
  end

  def mms_link media_info
    JSON.parse(media_info)["PARAMETERS"]["REDIRECT_URL"]
  end

  def session_expired? media_info
    JSON.parse(media_info)["PARAMETERS"]["error_session_expire"] == 1
  end

  private

  def grab_media_info link, cookie
    result = link.match(/(\w*)\/(\w*)\/(\w*)\/([\w|-]*)/)

    media_file = (not result.nil? and result.size > 2) ? result[3] : ""

    request_media_info media_file, cookie
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
