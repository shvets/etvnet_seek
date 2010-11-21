require "highline/import"
require 'optparse'
require 'date'

require 'etvnet_seek/commander'
require 'etvnet_seek/user_selection'
require 'runglish'

class Main
  COOKIE_FILE_NAME = ENV['HOME'] + "/.etvnet-seek"

  def initialize
    @cookie_helper = CookieHelper.new COOKIE_FILE_NAME
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

    if mode == 'access'
      process_access page, params[0]
    elsif mode == 'login'
      item = params[0]
      cookie = page.login(*get_credentials)

      @cookie_helper.save_cookie cookie

      process("access", item)
    else
      items = page.items

      if items.size > 0
        display_items items
        display_bottom_menu_part(mode)

        user_selection = read_user_selection items

        if not user_selection.quit?
          current_item = items[user_selection.index]
          if mode == 'main'
            case current_item.link
#              when '/' then
#                process("main")
              when /tv_channels/ then
                process('channels', current_item.link)
              when /aired_today/ then
                process('media', current_item.link)
              when /catalog/ then
                process('media', current_item.link)
              when /audio/ then
                process('audio', current_item.link)
              when /press/ then
                #process('channels', current_item.link)
            end
          elsif mode == 'channels'
            if user_selection.catalog?
              process('media', current_item.catalog_link)
            else
              process('media', current_item.link)
            end
          elsif mode == 'new_items'
            process('access', current_item)
          elsif mode == 'premiere'
            process('access', current_item)
          elsif mode == 'catalog'
            # p 'catalog'
            process('media', current_item.link)
          elsif mode == 'media'
            if current_item.folder? or current_item.link =~ /(catalog|tv_channel)/
              process('media', current_item.link)
            else
              process("access", current_item)
            end
          elsif mode == 'audio'
            case current_item.media_file
              when "" then
                process('radio')
              when "today_genres" then
                process('today_genres')
              when "newest" then
                process('newest')
              when "catalog" then
                process('catalog')
            end
          elsif mode == 'radio'
            media_info = MediaInfo.new current_item.link
            LinkInfo.new(current_item, media_info)
          else
            ;
          end
        end
      end
    end
  end

  def process_access page, item
    cookie = @cookie_helper.load_cookie

    if cookie.nil?
      process("login", item)
    else
      #expires = CookieHelper.get_expires(cookie)
      #cookie_expire_date =  DateTime.strptime(expires, "%A, %d-%b-%Y %H:%M:%S %Z")

#      if cookie_expire_date < DateTime.now # cookie expired?
#        @cookie_helper.delete_cookie

#        process("login", item)
#      else
      #media_info = page.request_media_info(item.media_file, cookie)

      result = cookie.scan(/sessid=([\d|\w]*);.*_lc=([\d|\w]*);.*/)

      short_cookie = "sessid=#{result[0][0]};_lc=#{result[0][1]}"
      media_info = page.request_media_info(item.link.scan(/.*\/(\d*)\//)[0][0], short_cookie)

      if media_info.session_expired?
        @cookie_helper.delete_cookie

        process("login", item)
      else
        LinkInfo.new(item, media_info)
      end
      #     end
    end
  end

  def get_credentials
    username = ask("Enter username :  ")
    password = ask("Enter password : ") { |q| q.echo = '*' }

    [username, password]
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
    puts "<number> => today; <number> c => catalog" if mode == 'channels'
    puts "q. to exit"
  end

  def launch_link link
    if RUBY_PLATFORM =~ /(win|w)32$/
      `start wmplayer #{link}`
    elsif RUBY_PLATFORM =~ /darwin/
      `open '#{link}'`
    end
  end

  private

  def read_keywords input
    keywords = input

    if (keywords.strip.size == 0)
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
    user_selection = UserSelection.new

    while true
      user_selection.parse(ask("Select the number: "))

      if not user_selection.blank?
        if user_selection.quit? or user_selection.index < items.size
          break
        else
          puts "Selection is out of range: [1..#{items.size}]"
        end
      end
    end

    user_selection
  end

end