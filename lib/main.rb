require 'rubygems' unless RUBY_VERSION =~ /1.9.*/

#require "readline"
require "highline/import"
require 'optparse'

require 'cookie_helper'
require 'user_selection'
require 'media_info'
require 'link_info'
require 'page/page_factory'
require 'page/access_page'
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
  end

  def seek *params
    if @commander.search_mode?
      params = read_keywords(*params)
      
      puts "Keywords: #{params}" if @commander.runglish_mode?
    end

    process @commander.get_initial_mode, params
  end

  def process mode, *params
    page = PageFactory.create(mode, params)
    items = page.items

    if items.size > 0
      display_items items
      display_bottom_menu_part(mode)

      user_selection = read_user_selection items

      if not user_selection.quit?
        current_item = user_selection.item(items)

        if mode == 'main'
          case current_item.link
            when /announces.html/ then
              process('announces', current_item.link)
            when /freeTV.html/ then
              process('freetv', current_item.link)
            when /category=/
              process('category', current_item.link)
            when /action=channels/
              process('channels', current_item.link)
          end
        elsif mode == 'channels'
          if user_selection.archive?
            process('archive', current_item.link)
          else
            process('today', current_item.link)
          end
        else # media : announces, freetv, category
          if current_item.folder?
            process('folder', current_item.link)
          else
            media_info = request_media_info(current_item.media_file)
            LinkInfo.new(current_item, media_info)
          end
        end
      end
    end
  end

  def display_items items
    if items.size == 0
      puts "Empty search result."
    else
      items.each_with_index do |item, index|
        puts "#{index+1}. #{item}"
      end
    end
  end

  def display_bottom_menu_part mode
    puts "<number> => today; <number>.a => archive" if mode == 'channels'
    puts "q. to exit"
  end

  def request_media_info media_file
    access_page = AccessPage.new

    media_info = access_page.request_media_info(media_file, @cookie_helper.cookie)

    if media_info.session_expired?
      @cookie_helper.renew_cookie
      media_info = access_page.request_media_info(media_file, @cookie_helper.cookie)
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