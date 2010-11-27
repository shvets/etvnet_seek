class BrowseMediaItem < MediaItem
  attr_accessor :folder, :showtime, :year, :duration, :image, :rating_image, :rating, :channel

  def initialize(text, link)
    super(text, link)
  end

  def folder?
    folder == true
  end

  def to_s
    #buffer = ""
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
    buffer += " --- #{channel}" if channel 
    buffer += " --- #{image}" if image
    buffer += " --- #{rating_image}" if rating_image
    
    buffer
  end

end
