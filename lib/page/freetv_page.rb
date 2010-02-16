require 'page/page'

class FreetvPage < Page
 def items
    list = []

    document.css("table tr td table tr td table tr td div table tr").each do |item|
      #next if index < 1
      node = item.css("td img")
      if node.size > 0
        text = node.at(0).parent.css("a")
        unless text.to_s.size == 0
          link = node.at(0).parent.css("a")
          text = link.at(0).text.strip
          href = link.at(0).attributes['href'].value.strip

          record = BrowseMediaItem.new(text, href)
          record.rating_image = node.at(0).attributes['src']

          list << record
        end
      end
    end

    list
  end
end
