require 'rubygems' unless RUBY_VERSION =~ /1.9.*/

#require "readline"
require "highline/import"
require 'optparse'

require 'cookie_helper'
require 'url_seeker'
require 'user_selection'
require 'media_info'
require 'link_info'
require 'commander'
require 'runglish'

class Main

  COOKIE_FILE_NAME = ENV['HOME'] + "/.etvnet-seek"

  def initialize
    @cookie_helper = CookieHelper.new COOKIE_FILE_NAME do
      username = ask("Enter username :  " )
      password = ask("Enter password : " ) { |q| q.echo = '*' }

      [username, password]
    end

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
        nil
      else
        current_item = user_selection.item(items)

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
            puts "************"
            else
              nil
          end

          link_info = seek(current_item.link)

        elsif @commander.channels_mode?
          if user_selection.archive?
            @commander.mode = 'archive'
          else
            @commander.mode = 'today'
          end
          p "in archive #{current_item.channel}"
          link_info = seek(current_item.channel)
        else
          if current_item.container
            @commander.mode = 'container'
            link_info = seek(current_item.link)
          else
            media_info = request_media_info current_item.media_file

            link_info = LinkInfo.new(current_item.underscore_name, current_item.text, current_item.media_file,
                                     media_info.link, media_info.session_expired?)
          end
        end

        #puts "Cannot get movie link..." unless link_info.nil?

        link_info
      end
    end
  end

  def display_bottom_menu_part
    puts "<number> => today; <number>.a => archive" if @commander.channels_mode?
    puts "q. to exit"
  end

  def request_media_info media_file
    media_info = MediaInfo.request_media_info(UrlSeeker::ACCESS_URL, media_file, @cookie_helper.cookie)

    if media_info.session_expired?
      @cookie_helper.renew_cookie
      media_info = MediaInfo.request_media_info(UrlSeeker::ACCESS_URL, media_file, @cookie_helper.cookie)
    end

    media_info
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

end