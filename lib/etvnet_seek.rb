require 'rubygems' unless RUBY_VERSION =~ /1.9.*/

require 'nokogiri'
require 'open-uri'
#require "readline"
require "highline/import"
require 'cgi'
require 'json'

require 'cookie_helper'

class EtvnetSeek
  include CookieHelper
  
  BASE_URL = "http://www.etvnet.ca"
  SEARCH_URL = BASE_URL + "/cgi-bin/video/eitv_browse.fcgi?action=search"
  ACCESS_URL = BASE_URL + "/cgi-bin/video/access.fcgi"
  LOGIN_URL =  BASE_URL + "/cgi-bin/video/login.fcgi"

  def cookie
    @cookie ||= get_cookie
  end

  def search keywords, order_direction = '-'
    search_items SEARCH_URL + "&keywords=#{CGI.escape(keywords)}&order_direction=#{order_direction}"
  end

  def search_items url
    doc = Nokogiri::HTML(open(url))

    list = []

    doc.css("table tr[2] td table").each do |item|
      links = item.css(".media_file")

      links.each_with_index do |link, index|
        if index % 2 != 0
          href = link.attributes['href'].value

          new_link = list.select {|l| l[:link] == href}.empty?

          if new_link
            record = {:link => href,
                      :name => link.content.strip,
  #                    :first_time => link.parent.parent.previous.previous.previous.previous.content.strip,
  #                    :year => link.parent.parent.next.next.content.strip,
  #                    :how_long => link.parent.parent.next.next.next.next.content.strip
            }

            if href =~ /action=browse_container/
              record[:container] = search_items(href)
            else
              result = href.match(/(\w*)\/(\w*)\/(\w*)\/([\w|-]*)/)

              record[:media_file] = (result.size > 2) ? result[3] : ""
              record[:english_name] = (result.size > 3) ? result[4] : ""
            end

            list << record
          end
        end
      end
    end

    list
  end

  def display_search_items items
    items.each_with_index do |item1, index1|

      if item1[:container].nil?
        puts "#{index1+1}. #{item1[:english_name]} --- #{item1[:media_file]} --- #{item1[:name]}"
      else
        puts "#{index1+1}. #{item1[:name]}"

        item1[:container].each_with_index do |item2, index2|
          puts "    #{index1+1}.#{index2+1}. #{item2[:english_name]} --- #{item2[:media_file]} --- #{item2[:name]}"
        end
      end
    end
  end

  def grab_movie_link link
    result = link.match(/(\w*)\/(\w*)\/(\w*)\/([\w|-]*)/)

    media_file = (not result.nil? and result.size > 2) ? result[3] : ""

    media_info = request_media_info media_file, cookie

    mms_link(media_info)
  end
  
  private

  def get_cookie
    file_name = ENV['HOME'] + "/.etvnet-seek"

    if File.exist? file_name
      cookie = read_user_file file_name
    else
      username = ask("Enter username :  " )
      password = ask("Enter password : " ) { |q| q.echo = '*' }

      cookie = retrieve_cookie LOGIN_URL, username, password

      write_user_file file_name, cookie
   end

    cookie
  end

  def read_user_file file_name
    File.open(file_name, 'r') do |file|
      return file.gets
    end
  end

  def write_user_file file_name, cookie
    File.open(file_name, 'w') do |file|
      file.puts cookie
    end
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

  def mms_link media_info
    JSON.parse(media_info)["PARAMETERS"]["REDIRECT_URL"]
  end
end
