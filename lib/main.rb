require 'rubygems' unless RUBY_VERSION =~ /1.9.*/

#require "readline"
require "highline/import"

require 'cookie_helper'
require 'url_seeker'

class Main
  include CookieHelper

  BASE_URL = "http://www.etvnet.ca"
  SEARCH_URL = BASE_URL + "/cgi-bin/video/eitv_browse.fcgi?action=search"
  ACCESS_URL = BASE_URL + "/cgi-bin/video/access.fcgi"
  LOGIN_URL =  BASE_URL + "/cgi-bin/video/login.fcgi"

  attr_reader :cookie

  def initialize
    @cookie = get_cookie
  end

  def self.search_url keywords, order_direction='-'
    SEARCH_URL + "&keywords=#{CGI.escape(keywords)}&order_direction=#{order_direction}"
  end

  def search_and_grab_link keywords
    if(keywords.strip.size == 0)
      while keywords.strip.size == 0
        keywords = ask("Keywords: ")
      end
    end

    url_seeker = UrlSeeker.new

    items = url_seeker.search Main.search_url(keywords)

    if items.size == 0
      say "Empty search result."
      link = nil
    else
      url_seeker.display_results items

      title_number = ask("Select title number: ")
      while not title_number =~ /(\d+)(\.?)(\d*)/
        title_number = ask("Select title number: ")
      end

      dot_index = title_number.index('.')

      if not dot_index.nil?
        pos1 = title_number[0..dot_index-1].to_i
        pos2 = title_number[dot_index+1..-1].to_i

        link = url_seeker.grab_movie_link items[pos1-1][:container][pos2-1][:link], cookie, ACCESS_URL
      else
        link = url_seeker.grab_movie_link items[title_number.to_i-1][:link], cookie, ACCESS_URL
      end
    end

    link
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
end