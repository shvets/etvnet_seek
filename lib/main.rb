require 'rubygems' unless RUBY_VERSION =~ /1.9.*/

#require "readline"
require "highline/import"

require 'cookie_helper'
require 'url_seeker'
require 'runglish'
require 'optparse'

class Main
  include CookieHelper

  COOKIE_FILE_NAME = ENV['HOME'] + "/.etvnet-seek"

  attr_reader :cookie, :options

  def initialize
    @cookie = get_cookie

    parse_options

    @mode = get_mode

    @url_seeker = UrlSeeker.new
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

      options[:main] = false
      opts.on( '-m', '--main', 'Display Main Menu' ) do
        options[:main] = true
      end

#      options[:channels] = false
#      opts.on( '-c', '--channels', 'Display Channels Menu' ) do
#        options[:channels] = true
#      end

      options[:popular] = false
      opts.on( '-p', '--popular', 'Display Popular Menu' ) do
        options[:popular] = true
      end

      options[:best_ten] = false
      opts.on( '-b', '--best-ten', 'Display Best 10 Menu' ) do
        options[:best_ten] = true
      end

      options[:we_recommend] = false
      opts.on( '-w', '--we-recommend', 'Display We recommend Menu' ) do
        options[:we_recommend] = true
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

  def get_mode
    mode = 'search'

    if options[:main] == true
      mode = 'main'
    elsif options[:best_ten] == true
      mode = 'best_ten'
    elsif options[:popular] == true
      mode = 'popular'
    elsif options[:we_recommend] == true
      mode = 'we_recommend'
    end

    mode
  end

  def search input
    items = get_items input

    retrieve_link items
  end

  def get_items input
    items = []

    case @mode
      when 'search' then
        keywords = read_keywords(input)
        puts "Keywords: #{keywords}"

        items = @url_seeker.search_items keywords
      when 'main' then
        items = @url_seeker.main_items
      when 'best_ten' then
        items = @url_seeker.best_ten_items
      when 'popular' then
        items = @url_seeker.popular_items
      when 'we_recommend' then
        items = @url_seeker.we_recommend_items
    end

    items
  end

  def retrieve_link items
    @url_seeker.display_items items
    puts "q. to exit"

    link = nil

    if items.size > 0
      title_number = read_title_number

      unless title_number.quit?
        media = @url_seeker.grab_media(items, title_number, cookie)

        link = @url_seeker.mms_link(media)

        if link.nil? and @url_seeker.session_expired?(media)
          delete_cookie
          @cookie = get_cookie
          media = @url_seeker.grab_media items, title_number, cookie
          link = @url_seeker.mms_link(media)
        end
        
        puts "Cannot get movie link..." if link.nil?
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
    input = ask("Select title number: ")

    unless ['q', 'Q'].include? input
      while not input =~ /(\d+)(\.?)(\d*)/ or input =~ /q/i
        input = ask("Select title number: ")
      end
    end

    TitleNumber.new input
  end

  def get_cookie
    if File.exist? COOKIE_FILE_NAME
      cookie = read_cookie COOKIE_FILE_NAME
    else
      username = ask("Enter username :  " )
      password = ask("Enter password : " ) { |q| q.echo = '*' }

      cookie = retrieve_cookie UrlSeeker::LOGIN_URL, username, password

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