require 'open-uri'
require 'nokogiri'
require 'cgi'

require 'media_item'

class GetServiceCall
  attr_reader :url, :uri

  def initialize(url)
    @url = url
    @uri = URI.parse(url)
  end

  def response
    open(url)
  end

  def response_low_level request
    connection = Net::HTTP.new(uri.host, uri.port)

    connection.request(request)
  end
end

class PostServiceCall
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def response request
    uri = URI.parse(url)
    connection = Net::HTTP.new(uri.host, uri.port)

    headers = { "Content-Type" => "application/x-www-form-urlencoded" }
    connection.post(uri.path, request, headers)
  end
end

class Page < GetServiceCall
  BASE_URL = "http://www.etvnet.ca"

  def initialize(url = BASE_URL)
    super(url.index(BASE_URL).nil? ? "#{BASE_URL}/#{url}" : url)
  end

  def get_document
    Nokogiri::HTML(response)
  end
end

class BasePage < Page
  def get_items
    list = []

    get_document.css("#tblCategories a").each do |item|
      text = item.css("img").at(0).attributes['alt'].value
      href = item['href']

      list << MediaItem.new(text, href)
    end

    list.delete_at(0)

    list
  end

end

class AnnouncesPage < Page
  def get_items
    list = []

    get_document.css("table tr td div").each do |item|
      unless item.css("a").at(0).nil?
        text = item.css("img").at(0).attributes['alt'].value.strip
        href = item.css("a").at(0).attributes['href'].value

        list << BrowseMediaItem.new(text, href)
      end
    end

    list
  end
end

class FreetvPage < Page
 def get_items
    list = []
        puts url
    get_document.css("table tr td table tr td table tr td div table tr").each do |item|
      #next if index < 1
      node = item.css("td img")
      if node.size > 0
        text = node.at(0).parent.css("a")
        unless text.to_s.size == 0
          link = node.at(0).parent.css("a")
          text = link.at(0).text.strip
          href = link.at(0).attributes['href'].value.strip

          record = BrowseMediaItem.new(text, href)
          record.rating_image = node.at(0).attributes['src']

          list << record
        end
      end
    end

    list
  end
end

class MediaPage < Page
  def get_items
    list = []

    get_document.css("b a.media_file").each do |item|
      link = item.attributes['href'].value
      new_link = list.select {|l| l.link == link}.empty?

      if new_link
        record = BrowseMediaItem.new(item.content.strip, link)

        record.showtime = item.parent.parent.parent.css('td[1]').text.strip
        record.year = item.parent.parent.next.next.content.strip

        if link =~ /action=browse_container/
          record.folder = true
        else
          record.duration = item.parent.parent.next.next.next.next.content.strip unless
            item.parent.parent.next.next.next.next.nil?
  #        record.stars = ""
  #        record.rating = ""
        end

        list << record
      end
    end

    list
  end
end


class SearchPage < MediaPage
  SEARCH_URL = BASE_URL + "/cgi-bin/video/eitv_browse.fcgi?action=search"

  def initialize(params)
    super("#{SEARCH_URL}&keywords=#{CGI.escape(*params)}&order_direction=-")
  end
end

class ChannelsPage < Page
  BROWSE_URL   = BASE_URL + "/cgi-bin/video/eitv_browse.fcgi"
  CHANNELS_URL = BROWSE_URL + "?action=channels"

  def initialize url = CHANNELS_URL
    super(url)
  end

  def get_items
    list = []

    get_document.css("table table table.rounded_white table tr").each_with_index do |item, index|
      links = item.css("table tr td a")

      text = item.children.at(0).text.strip

      if text.size > 0
        link = nil
        archive_link = nil

        if links.size > 0
          href = links[0]
          archive_href = links[1]

          link = href.attributes['href'].value unless href.nil?

          archive_link = archive_href.attributes['href'].value unless archive_href.nil?
        end

        list << ChannelMediaItem.new(text, link, archive_link)
      end
    end

    list
  end

end

class GroupPage < Page
  protected

  def get_typical_items url, tag_name
    list = []

    get_document.css(tag_name).at(0).next.children.each do |table|
      href = table.css("a").at(0)

      unless href.nil?
        link = href.attributes['href'].value
        text = href.children.at(0).content

        if link =~ /media/
          additional_info = additional_info(href, 1)

          text += additional_info unless additional_info.nil?
        end

        record = BrowseMediaItem.new(text, link)

        list << record
      end
    end

    list
  end

  def additional_info node, index
    children = node.parent.children
    if children.size > 0
      children.at(index)
    else
      nil
    end
  end
end

class BestTenPage < GroupPage
  def get_items
    get_typical_items(url, "#tbl10best")
  end
end

class PopularPage < GroupPage
  def get_items
    get_typical_items(url, "#tblyearago")
  end
end

class WeRecommendPage < GroupPage
  def get_items
    items = get_typical_items(url, "#tblfree")

#    more_recommended_item = items.delete_at(items.size-1)
#
#    more_recommended_items = get_menu_items(UrlSeeker::BASE_URL + more_recommended_item.link)
#
#    items.concat more_recommended_items

    items
  end
end

class AccessPage < GetServiceCall
  ACCESS_URL = Page::BASE_URL + "/cgi-bin/video/access.fcgi"

  def initialize
    super(ACCESS_URL)
  end

  def request media_file, cookie
    headers = { 'Cookie' => cookie }

    request = Net::HTTP::Post.new(uri.request_uri, headers)

    request.set_form_data(
      { 'action' => 'start_video', 'bitrate' => '600',
        'media_file'=> media_file, 'replay' => '1', 'skin' => 'JSON'
      }
    )

    request
  end

  def request_media_info media_file, cookie
    response = response_low_level(request(media_file, cookie))

    media_info = response.body

    link = JSON.parse(media_info)["PARAMETERS"]["REDIRECT_URL"]
    session_expired = (JSON.parse(media_info)["PARAMETERS"]["error_session_expire"] == 1)

    MediaInfo.new link, session_expired
  end
end

class CookiePage < PostServiceCall
  LOGIN_URL = "#{Page::BASE_URL}/cgi-bin/video/login.fcgi"

  def initialize
    super(LOGIN_URL)
  end

  def retrieve_cookie username, password
    params = "action=login&username=#{username}&pwd=#{password}&skip_notice=&redirect="

    response = response(*params)

    response.response['set-cookie']
  end
end

class PageFactory
  def self.create mode, params
    url = (mode == 'search') ? nil : params[0]
    
    case mode
      when 'search' then
        page = SearchPage.new *params
      when 'folder' then
        page = MediaPage.new url
      when 'main' then
        page = BasePage.new
      when 'channels' then
        page = ChannelsPage.new
      when 'best_ten' then
        page = BestTenPage.new
      when 'popular' then
        page = PopularPage.new
      when 'we_recommend' then
        page = WeRecommendPage.new
      when 'today' then
        page = MediaPage.new url
      when 'archive' then
        page = MediaPage.new url
      when 'announces' then
        page = AnnouncesPage.new url
      when 'freetv' then
        page = FreetvPage.new url
      when 'category' then
        page = MediaPage.new url
      when 'media' then
        page = MediaPage.new url
      else
        page = nil
    end

    page
  end
end