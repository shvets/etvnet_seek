class BasePage < Page

  def items
    list = []

    document.css("#tblCategories a").each do |item|
      text = item.css("img").at(0).attributes['alt'].value
      href = item['href']

       unless href =~ /(forum|action=browse_persons|valentines2010)/
        list << MediaItem.new(text, href)
       end
    end

    list.delete_at(0)

    list
  end
  
  def title
    document.css("title").text
  end

  def page_title
    document.css(".global_content .global_content h1").text
  end

  protected

  def additional_info node, index
    children = node.parent.children
    if children.size > 0
      element = children.at(index)
      element.text if element
    end
  end
end
