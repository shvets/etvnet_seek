class HomePage < Page

  def items
    list = []

    document.css("#nav a").each do |item|
      text = item.css("span").text.strip
      href = item['href']
      
      unless href == '/' or href =~ /register/
        list << MediaItem.new(text, href)
      end
    end

    list
  end
  
end
