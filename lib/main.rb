require 'rubygems' unless RUBY_VERSION =~ /1.9.*/

#require "readline"
require "highline/import"

require 'cookie_helper'
require 'url_seeker'
require 'runglish'
require 'optparse'

class Main
  include CookieHelper

  BASE_URL = "http://www.etvnet.ca"
  SEARCH_URL = BASE_URL + "/cgi-bin/video/eitv_browse.fcgi?action=search"
  ACCESS_URL = BASE_URL + "/cgi-bin/video/access.fcgi"
  LOGIN_URL =  BASE_URL + "/cgi-bin/video/login.fcgi"

  COOKIE_FILE_NAME = ENV['HOME'] + "/.etvnet-seek"

  attr_reader :cookie, :options

  def initialize
    @cookie = get_cookie
  end

  def self.search_url keywords, order_direction='-'
    SEARCH_URL + "&keywords=#{CGI.escape(keywords)}&order_direction=#{order_direction}"
  end

  def parse_options
    # This hash will hold all of the options
    # parsed from the command-line by
    # OptionParser.
    @options = {}

    optparse = OptionParser.new do|opts|
      # Set a banner, displayed at the top
      # of the help screen.
      opts.banner = "Usage: etvnet_seek [options] keywords"

      options[:runglish] = false
      opts.on( '-r', '--runglish', 'Enter russian keywords in translit' ) do
        options[:runglish] = true
      end

      # This displays the help screen, all programs are
      # assumed to have this option.
      opts.on( '-h', '--help', 'Display this screen' ) do
        puts opts
        exit
      end
    end

    optparse.parse!
  end

  def search_and_grab_link input
    keywords = read_keywords(input)
    
    url_seeker = UrlSeeker.new

    items = url_seeker.search Main.search_url(keywords)

    url_seeker.display_results items

    link = nil

    if items.size > 0
      title_number = read_title_number

      link = url_seeker.grab_media_link(items, title_number, cookie, ACCESS_URL) do
        delete_cookie
        @cookie = get_cookie
      end
     end

    link
  end

  def launch_link link
    if RUBY_PLATFORM =~ /(win|w)32$/
      `start wmplayer #{link}`
    elsif RUBY_PLATFORM =~ /darwin/
      `open #{link}`
    end
  end

  private

  def read_keywords input
    keywords = input

    if(keywords.strip.size == 0)
      while keywords.strip.size == 0
        keywords = ask("Keywords: ")
      end
    end

    if RUBY_PLATFORM =~ /mswin32/ or options[:runglish]
      keywords = Runglish.new.lat_to_ru(keywords)
    end

    keywords
  end

  def read_title_number
    title_number = ask("Select title number: ")

    while not title_number =~ /(\d+)(\.?)(\d*)/
      title_number = ask("Select title number: ")
    end

    title_number
  end

  def get_cookie
    if File.exist? COOKIE_FILE_NAME
      cookie = read_cookie COOKIE_FILE_NAME
    else
      username = ask("Enter username :  " )
      password = ask("Enter password : " ) { |q| q.echo = '*' }

      cookie = retrieve_cookie LOGIN_URL, username, password

      write_cookie COOKIE_FILE_NAME, cookie
   end

    cookie
  end

  def delete_cookie
    File.delete COOKIE_FILE_NAME if File.exist? COOKIE_FILE_NAME
  end

  def read_cookie file_name
    File.open(file_name, 'r') { |file| file.gets }
  end

  def write_cookie file_name, cookie
    File.open(file_name, 'w') { |file| file.puts cookie }
  end
end