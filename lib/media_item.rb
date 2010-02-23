class MediaItem
  attr_reader :text, :link

  def initialize(text, link)
    @text = text
    @link = link
  end

  def folder?
    false
  end

  def ==(object)
    object.text == text and object.link == link
  end

  def to_s
    text
  end  
end
