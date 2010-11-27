require 'etvnet_seek/core/media_item'

class GroupMediaItem < MediaItem

  def to_s
    "#{text} ---  #{link}"
  end

end
