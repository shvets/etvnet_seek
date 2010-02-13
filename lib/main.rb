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

    @commander = Commander.new

    @url_seeker = UrlSeeker.new
  end

  def seek *params
    if @commander.search_mode?
      params = read_keywords(*params)
      
      puts "Keywords: #{params}" if @commander.runglish_mode?
    end

    items = @url_seeker.get_items(@commander.mode, *params)

    @url_seeker.display_items items   
    display_bottom_menu_part

    if items.size == 0
      nil
    else
      user_selection = read_user_selection items

      if user_selection.quit?
        LinkInfo.new
      else
        current_item = items[user_selection.index1]

        if @commander.main_menu_mode?
          case current_item.link
            when /announces.html/ then
              @commander.mode = 'announces'
            when /freeTV.html/ then
              @commander.mode = 'freetv'
            when /category=/
              @commander.mode = 'category'
            when /action=channels/
              @commander.mode = 'channels'
            else
              LinkInfo.new
          end

          link_info = seek(current_item.link)

        elsif @commander.channels_mode?
          if user_selection.archive?
            @commander.mode = 'archive'
          else
            @commander.mode = 'today'
          end

          link_info = seek(current_item.channel)
        else
          if current_item.container
            @commander.mode = 'container'
            link_info = seek(current_item.link)
          else
            link_info = retrieve_link items, user_selection
          end
        end

        puts "Cannot get movie link..." unless link_info.resolved?

        link_info
      end
    end
  end

  def display_bottom_menu_part
    puts "<number> => today; <number>.a => archive" if @commander.channels_mode?
    puts "q. to exit"
  end

  def retrieve_link items, user_selection
    link_info = @url_seeker.collect_link_info(items, user_selection, cookie)

    if link_info.link.nil? and link_info.session_expired?
      delete_cookie
      @cookie = get_cookie
      link_info = @url_seeker.collect_link_info(items, user_selection, cookie)
    end

    link_info
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
      user_selection = UserSelection.new ask("Select the number: ")
      
      if not user_selection.blank?
        if user_selection.quit? or user_selection.index1 < items.size
          return user_selection
        else
          puts "Selection is out of range: [1..#{items.size}]"
        end
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