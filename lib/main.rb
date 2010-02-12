require 'rubygems' unless RUBY_VERSION =~ /1.9.*/

#require "readline"
require "highline/import"
require 'optparse'

require 'cookie_helper'
require 'url_seeker'
require 'commander'
require 'runglish'

class Main
  include CookieHelper

  COOKIE_FILE_NAME = ENV['HOME'] + "/.etvnet-seek"

  attr_reader :cookie

  def initialize
    @cookie = get_cookie

    @url_seeker = UrlSeeker.new

    @commander = Commander.new
  end

  def seek *params
    if @commander.search_mode?
      input = read_keywords(*params)
      
      puts "Keywords: #{input}" if @commander.runglish_mode?

      items = @url_seeker.get_items(@commander.mode, input)
    else
      items = @url_seeker.get_items(@commander.mode, *params)
    end

    @url_seeker.display_items items
    puts "<number> => today; <number>.a => archive" if @commander.channels_mode?
    puts "q. to exit"

    if items.size == 0
      nil
    else
      user_selection = read_user_selection items

      if user_selection.quit?
        nil
      else
        if @commander.main_menu_mode?
          #
        elsif @commander.channels_mode?
          if user_selection.archive?
            @commander.mode = 'archive'
            link, english_name = seek(items[user_selection.index1].channel)
          else
            @commander.mode = 'today'
            link, english_name = seek(items[user_selection.index1].channel)
          end
        else
          link, english_name = retrieve_link items, user_selection
        end

        puts "Cannot get movie link..." if link.nil?

        [link, english_name]
      end
    end
  end

  def retrieve_link items, user_selection
    media, english_name = @url_seeker.grab_media(items, user_selection, cookie)
    link = @url_seeker.mms_link(media)

    if link.nil? and @url_seeker.session_expired?(media)
      delete_cookie
      @cookie = get_cookie
      media, english_name = @url_seeker.grab_media items, user_selection, cookie
      link = @url_seeker.mms_link(media)
    end

    [link, english_name]
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

    if RUBY_PLATFORM =~ /mswin32/ or @commander.runglish_mode?
      keywords = Runglish::LatToRusConverter.new.transliterate(keywords)
    end

    keywords
  end

  def read_user_selection items
    while true
      user_selection = UserSelection.new ask("Select title number: ")

      if user_selection.quit? or user_selection.index1 < items.size
        return user_selection
      else
        puts "Selection is out of range: [1..#{items.size}]"
      end
    end
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