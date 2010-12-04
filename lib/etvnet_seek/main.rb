require "highline/import"
require 'optparse'
require 'date'

require 'etvnet_seek/commander'
require 'etvnet_seek/user_selection'
require 'etvnet_seek/accessor'
require 'runglish'

require 'etvnet_seek/link_info'
require 'etvnet_seek/core/items_page_factory'
require 'etvnet_seek/core/items_page'

class Main
  COOKIE_FILE_NAME = ENV['HOME'] + "/.etvnet-seek"

  def initialize
    @commander = Commander.new
    @accessor = Accessor.new COOKIE_FILE_NAME, lambda { get_credentials }
  end

  def process *params
    mode = @commander.get_initial_mode

    case mode
      when /(search|translit)/ then
        keywords = read_keywords(*params)
        puts "Keywords: #{keywords}" if @commander.translit_mode?

        process_folder "search", keywords
      when 'main' then
        main
      when 'channels' then
        channels
      when 'catalog' then
        process_folder "catalog"
      when 'best_hundred' then
        best_hundred
      when 'top_this_week' then
        top_this_week
      when 'premiere' then
        process_folder "premiere"
      when 'new_items' then
        process_folder "new_items"
    end
  end

  def main
    process_items "main" do |item, _|
      case item.link
        when /tv_channels/ then
          channels
        when /(aired_today|catalog)/ then
          process_folder "media", item.link
        when /audio/ then
          audio item.link
      end
    end
  end

  def channels
    process_items "channels" do |item, user_selection|
      link = user_selection.catalog? ? item.catalog_link : item.link

      process_folder "media", link
    end
  end

  def best_hundred
    process_items "best_hundred" do |item, _|
      process_group item, item.link =~ /best100/
    end
  end

  def top_this_week
    process_items "top_this_week" do |item, _|
      process_group item, item.link =~ /top_this_week/
    end
  end

  def process_group item, next_group
    if next_group
      process_items "media", item.link do |media_item, _|
        access_or_media item, (folder?(media_item) or not media_item.access_page?)
      end
    else
      access_or_media item, (folder?(item) or not item.access_page?)
    end
  end

  def folder? item
    item.link =~ /(catalog|tv_channel)/ || item.folder?
  end

  def process_folder name, *params
    process_items name, *params do |item, _|
      access_or_media item, folder?(item)
    end
  end

  def audio root
    process_items "audio", root do |item1, _|
      process_items "radio", item1.link do |item2, _|
        media_info = MediaInfo.new item2.link
        LinkInfo.new(item2, media_info)
      end
    end
  end

  def access_or_media item, folder
    if folder
      process_folder "media", item.link
    else
      result = @accessor.access item

      while(@accessor.try_again? or result.nil?) do
        result = @accessor.access item
      end

      result
    end
  end

  def get_credentials
    username = ask("Enter username :  ")
    password = ask("Enter password : ") { |q| q.echo = '*' }

    [username, password]
  end

  def process_items mode, *params
    page = ItemsPageFactory.create mode, *params

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