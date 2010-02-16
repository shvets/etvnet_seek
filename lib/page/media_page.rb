require 'page/page'

class MediaPage < Page
  def items
    list = []

    document.css("b a.media_file").each do |item|
      link = item.attributes['href'].value
      new_link = list.select {|l| l.link == link}.empty?

      if new_link
        record = BrowseMediaItem.new(item.content.strip, link)

        record.showtime = item.parent.parent.parent.css('td[1]').text.strip
        record.year = item.parent.parent.next.next.content.strip

        if link =~ /action=browse_container/
          record.folder = true
        else
          record.duration = item.parent.parent.next.next.next.next.content.strip unless
            item.parent.parent.next.next.next.next.nil?
  #        record.stars = ""
  #        record.rating = ""
        end

        list << record
      end
    end

    list
  end
end
