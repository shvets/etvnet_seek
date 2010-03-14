class CatalogItem < MediaItem
  attr_accessor :folder, :showtime, :duration, :year, :rating_image, :rating, :channel

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
    buffer += " --- #{duration}" if not duration.nil? and duration.size > 0
    buffer += " --- #{year}" if not year.nil? and year.size > 2

    buffer += " --- #{channel}" if channel    
    buffer += " --- #{rating_image}" if rating_image
    buffer += " --- #{rating}" if rating

    buffer
  end

end
