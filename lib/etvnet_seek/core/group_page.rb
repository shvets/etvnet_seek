class GroupPage < BasePage
  protected

  def get_typical_items tag_name, parent=nil
    list = []

    root = parent.nil? ? document : parent

    root.css(tag_name).each do |item|
      href = item.css("a").at(0)
      
      unless href.nil?
        link = href.attributes['href'].value
        text = href.children.at(0).content
        
        list << GroupMediaItem.new(text, link)
      end
    end

    list
  end
end


