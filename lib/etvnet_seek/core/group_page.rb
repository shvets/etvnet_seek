class GroupPage < BasePage
  protected

  def get_typical_items tag_name
    list = []

    document.css(tag_name).each do |item|
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

class BestHundredPage < GroupPage
  def items
    list = get_typical_items("ul.best-list li")

    node = document.css("ul.best-list").at(0).next

    unless node.nil?
      link = node.attributes['href'].value
      text = node.children.at(0).content

      list << GroupMediaItem.new(text, link)
    end
  end
end

class PremierePage < GroupPage
  def items
    get_typical_items("ul.recomendation-list li")
  end
end

