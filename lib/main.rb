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
      new_params = read_keywords(*params)
      
      puts "Keywords: #{new_params}" if @commander.runglish_mode?
    else
      new_params = params
    end

    items = @url_seeker.get_items(@commander.mode, *new_params)

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
          link = items[user_selection.index1].link

          case link
            when /announces.html/ then
              @commander.mode = 'announces'
            when /freeTV.html/ then
              @commander.mode = 'freetv'
            when /category=/
              @commander.mode = 'category'
            when /action=channels/
              @commander.mode = 'channels'
            else
              nil
          end

          result = seek(link)

        elsif @commander.channels_mode?
          if user_selection.archive?
            @commander.mode = 'archive'
          else
            @commander.mode = 'today'
          end

          result = seek(items[user_selection.index1].channel)
        else
          result = retrieve_link items, user_selection
        end

        puts "Cannot get movie link..." if link.nil?

        result
      end
    end
  end

  def retrieve_link items, user_selection
    result = @url_seeker.grab_media(items, user_selection, cookie)

    if result.link.nil? and @url_seeker.session_expired?(media)
      delete_cookie
      @cookie = get_cookie
      result = @url_seeker.grab_media items, user_selection, cookie
    end

    result
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