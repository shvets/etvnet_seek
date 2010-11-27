require "highline/import"
require 'optparse'
require 'date'

require 'etvnet_seek/commander'
require 'etvnet_seek/user_selection'
require 'runglish'
require 'etvnet_seek/core/items_page'

class Main
  COOKIE_FILE_NAME = ENV['HOME'] + "/.etvnet-seek"

  def initialize
    @cookie_helper = CookieHelper.new COOKIE_FILE_NAME
    @commander = Commander.new
  end

  def process *params
    mode = @commander.get_initial_mode

    case mode
      when /(search|translit)/ then
        keywords = read_keywords(*params)

        puts "Keywords: #{keywords}" if @commander.translit_mode?

        search keywords
      when 'main' then
        main
      when 'channels' then
        channels
      when 'catalog' then
        catalog
      when 'best_hundred' then
        best_hundred
      when 'top_this_week' then
        top_this_week
      when 'premiere' then
        premiere
      when 'new_items' then
        new_items
    end
  end

#    if mode == 'access'
#      page = AccessPage.new
#      page.process params[0], @cookie_helper
#    elsif mode == 'login'
#      page = LoginPage.new
#      page.process params[0], @cookie_helper
#    else

  def search keywords
    process_items "search", keywords do |item, _|
      access_or_media item, folder?(item)
    end
  end

  def main
    process_items "main" do |item1, _|
      case item1.link
        when /tv_channels/ then
          channels
        when /(aired_today|catalog)/ then
          media item1.link
        when /audio/ then
          audio item1.link, item1.media_file
      end
    end
  end

  def channels
    process_items "channels" do |item, user_selection|
      link = user_selection.catalog? ? item.catalog_link : item.link

      media link
    end
  end

  def catalog
    process_items "catalog" do |item, _|
      access_or_media item, folder?(item)
    end
  end

  def best_hundred
    process_items "best_hundred" do |item, _|
      group item, item.link =~ /best100/
    end
  end

  def top_this_week
    process_items "top_this_week" do |item, _|
      group item, item.link =~ /top_this_week/
    end
  end

  def group item1, next_group
    if next_group
      process_items "media", item1.link do |item2, _|
        result = nil
        # try to treat item as a folder
        process_items "media", item2.link do |item3, _|
          result = access item3
        end

        # otherwise try to treat item as a file
        result = access item2 if result.nil?

        result
      end
    else
      process_items "media", item1.link do |item2, _|
        access_or_media item2, folder?(item2)
      end
    end
  end

  def folder? item
    item.link =~ /(catalog|tv_channel)/ || item.folder?
  end

  def premiere
    process_items "premiere" do |item, _|
      access_or_media item, folder?(item)
    end
  end

  def new_items
    process_items "new_items" do |item, _|
      access_or_media item, folder?(item)
    end
  end

  def media root
    process_items "media", root do |item, _|
      access_or_media item, folder?(item)
    end
  end

  def access_or_media item, folder
    if folder
      media item.link
    else
      access item
    end
  end

  def access item
    page = AccessPage.new @cookie_helper
    page.process item
  end

  def audio root
    process_items "audio", root do |item1, _|
      process_items "radio", item1.link do |item2, _|
        media_info = MediaInfo.new item2.link
        LinkInfo.new(item2, media_info)
      end
    end
  end

#      case type
#        when "radio" then
#        when "today_genres" then
#        when "newest" then
#        when "catalog" then
#      end

  def process_items mode, url = nil
    page = ItemsPage.new mode, url

    items = page.items

    if items.size > 0
      display_items items
      display_bottom_menu_part(mode)

      user_selection = read_user_selection items

      if not user_selection.quit?
        current_item = items[user_selection.index]

        yield(current_item, user_selection) if block_given?
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

    if RUBY_PLATFORM =~ /mswin32/ or @commander.translit_mode?
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