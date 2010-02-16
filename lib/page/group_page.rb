require 'page/page'

class GroupPage < Page
  protected

  def get_typical_items url, tag_name
    list = []

    document.css(tag_name).at(0).next.children.each do |table|
      href = table.css("a").at(0)

      unless href.nil?
        link = href.attributes['href'].value
        text = href.children.at(0).content

        if link =~ /media/
          additional_info = additional_info(href, 1)

          text += additional_info unless additional_info.nil?
        end

        record = BrowseMediaItem.new(text, link)

        list << record
      end
    end

    list
  end

  def additional_info node, index
    children = node.parent.children
    if children.size > 0
      children.at(index)
    else
      nil
    end
  end
end

class BestTenPage < GroupPage
  def get_items
    get_typical_items(url, "#tbl10best")
  end
end

class PopularPage < GroupPage
  def get_items
    get_typical_items(url, "#tblyearago")
  end
end

class WeRecommendPage < GroupPage
  def get_items
    items = get_typical_items(url, "#tblfree")

#    more_recommended_item = items.delete_at(items.size-1)
#
#    more_recommended_items = get_menu_items(UrlSeeker::BASE_URL + more_recommended_item.link)
#
#    items.concat more_recommended_items

    items
  end
end
