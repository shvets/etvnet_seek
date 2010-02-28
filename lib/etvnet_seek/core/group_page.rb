class GroupPage < BasePage
  protected

  def get_typical_items tag_name
    list = []

    document.css(tag_name).at(0).next.children.each do |table|
      href = table.css("a").at(0)

      unless href.nil?
        link = href.attributes['href'].value
        text = href.children.at(0).content
        channel = ""

        if link =~ /media/
          additional_info = additional_info(href, 1)

          channel = additional_info.gsub(/\(|\)/, '') unless additional_info.nil?
        end
        
        list << GroupMediaItem.new(text, link, channel)
      end
    end

    list
  end
end

class BestTenPage < GroupPage
  def items
    get_typical_items("#tbl10best")
  end
end

class PopularPage < GroupPage
  def items
    get_typical_items("#tblyearago")
  end
end

class WeRecommendPage < GroupPage
  def items
    get_typical_items("#tblfree")
  end
end
