class BasePage < Page
  
  def title
    document.css("title").text
  end

  def page_title
    document.css(".conteiner h1").text
  end

  protected

  def collect_links path
    list = []

    document.css("#{path} a").each do |item|
      href = item.attributes['href'].value
      text = item.text

      list << MediaItem.new(text, href)
    end

    list
  end

  def collect_images path
    list = []

    document.css("#{path} img").each do |item|
      list << item.attributes['src'].value.strip
    end

    list
  end

  def additional_info node, index
    children = node.parent.children
    if children.size > 0
      element = children.at(index)
      element.text if element
    end
  end
end
