require 'media_item'

class BrowseMediaItem < MediaItem
  attr_accessor :folder, :showtime, :starts, :rating, :info_link, :year, :duration, :rating_image, :image
  attr_reader :underscore_name, :media_file

  def initialize(text, link)
    super(text, link)

    @underscore_name = extract_underscore_name
    @media_file = extract_media_file
  end

  def folder?
    folder == true
  end

  def to_s
    if folder?
      buffer = "*** Folder *** "
    else
      buffer = ""
    end

    buffer += text

    unless folder?
      if underscore_name
        buffer += ": #{underscore_name}"
      else
        buffer += ": #{link}"
      end
    end

    buffer += " --- #{showtime}" if showtime

    buffer += " (#{media_file})" if not media_file.nil? and media_file.size > 0
    buffer += " --- #{year}" if not year.nil? and year.size > 2
    buffer += " --- #{duration}" if not duration.nil? and duration.size > 0
    buffer += " --- #{image}" if image
    buffer += " --- #{rating_image}" if rating_image

    buffer
  end

  private

  def extract_underscore_name
    result = link.match(/(\w*)\/(\w*)\/(\w*)\/([\w|-]*)/)

    return nil if result.nil?

    (result.size > 3) ? result[4] : ""
  end

  def extract_media_file
    result = link.match(/(\w*)\/(\w*)\/(\w*)\/([\w|-]*)/)

    (not result.nil? and result.size > 2) ? result[3] : ""
  end
end
