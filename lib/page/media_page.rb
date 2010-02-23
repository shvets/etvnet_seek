require 'page/base_page'
require 'media_item'
require 'browse_media_item'

class MediaPage < BasePage
  def items
    list = []

    document.css("b a.media_file").each do |item|
      link = item.attributes['href'].value
      new_link = list.select {|l| l.link == link}.empty?

      if new_link
        text = item.content.strip
        additional_info = additional_info(item, 1)

        text += additional_info unless additional_info.nil?

        showtime = item.parent.parent.parent.css('td[1]').text.strip
        year = item.parent.parent.next.next.content.strip
        duration = ""

        if link =~ /action=browse_container/
          folder = true
          link = link[Page::BASE_URL.size..link.size]
        else
          folder = false
          duration = item.parent.parent.next.next.next.next.content.strip unless
            item.parent.parent.next.next.next.next.nil?
        end

        record = BrowseMediaItem.new(text, link)
        record.folder = folder
        record.showtime = showtime
        record.year = year
        record.duration = duration

        list << record
      end
    end

    list
  end

  def item_titles
    list = []

    document.css("table tr[2] td table tr td table tr[2] td[2] table").each_with_index do |item1, index1|

      if index1 == 1
        item1.css("tr[1] td").each do |item2|
          node = item2.children.at(0)
          text = node.text.strip

          if node.text? and not text.size == 0
            list << MediaItem.new(text)
          elsif node.element? and not text.size == 0
             list << MediaItem.new(text, node.attributes['href'].value)
          end
        end
      end
    end

    list
  end  

end


