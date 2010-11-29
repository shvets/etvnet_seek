require 'nokogiri'
require 'open-uri'

class MediaItem
  attr_reader :text, :link, :additional_info
  attr_reader :underscore_name, :media_file

  def initialize(text, link, additional_info = nil)
    @text = text
    @link = link
    @additional_info = additional_info

    @underscore_name = extract_underscore_name
    @media_file = extract_media_file
  end

  def folder?
    false
  end

#  def has_media_links?
#    page = Page.new link
#
#    page.document.css("b a.media_file").size > 0
#  end

  def access_page?
    page = Page.new link

    page.document.css(".start-video start-movie").size > 0
  end

  def ==(object)
    object.text == text and object.link == link
  end

  def to_s
    text
  end

  private

  def extract_underscore_name
    return nil if link.nil?

    result = link.match(/(\w*)\/(\w*)\/(\w*)\/([\w|-]*)/)

    return nil if result.nil?

    (result.size > 3) ? result[4] : ""
  end

  def extract_media_file
    return nil if link.nil?

    result = link.split('/')

    (not result.nil? and result.size > 2) ? result[2] : ""
  end
end
