class NewItem < MediaItem

  attr_accessor :image
  
  def to_s
    "#{text} ---  #{link}"
  end

end
