require 'nokogiri'
require 'open-uri'
require 'cgi'
require 'json'

require 'items_helper'
require 'user_selection'
require 'link_info'

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
        search_url = "#{SEARCH_URL}&keywords=#{CGI.escape(*params)}&order_direction=#{params[1]}"

        get_menu_items search_url
      when 'container' then
        get_menu_items *params
      when 'main' then
        get_main_menu_items BASE_URL
      when 'channels' then
        get_channel_items CHANNELS_URL
      when 'best_ten' then
        get_best_ten_items BASE_URL
      when 'popular' then
        get_popular_items BASE_URL
      when 'we_recommend' then
         get_we_recommend_items BASE_URL
      when 'today' then
        get_menu_items "#{TODAY_URL}&channel=#{params[0]}"
      when 'archive' then
        get_menu_items "#{BROWSE_URL}?channel=#{params[0]}"
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
          puts "#{index1+1}. #{item1}"

#          item1.container.each_with_index do |item2, index2|
#            puts "  #{index1+1}.#{index2+1}. #{item2}"
#          end
        else
          puts "#{index1+1}. #{item1}"
        end
      end
    end
  end

  def collect_link_info items, user_selection, cookie
    LinkInfo.extract(user_selection.item(items), ACCESS_URL, cookie)
  end

end
