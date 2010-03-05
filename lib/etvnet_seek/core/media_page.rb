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

        tr = item.parent.parent.parent

#        showtime = item.parent.parent.parent.css('td[1]').text.strip
#        year = item.parent.parent.next.next.content.strip
#        duration = ""

        showtime = tr.css("td[1]").text.strip

        year = tr.css("td[4]") ? tr.css("td[4]").text.strip : ""
        duration = tr.css("td[5]").text.strip ? tr.css("td[5]").text.strip : ""
        channel = tr.css("td[6]") ? tr.css("td[6]").text.strip : ""

        if link =~ /action=browse_container/
          folder = true
          link = link[Page::BASE_URL.size..link.size]
        else
          folder = false
#          duration = item.parent.parent.next.next.next.next.content.strip unless
#            item.parent.parent.next.next.next.next.nil?
        end

        record = BrowseMediaItem.new(text, link)
        record.folder = folder
        record.showtime = showtime
        record.year = year
        record.duration = duration
        record.channel = channel
        
        list << record
      end
    end

    list
  end  

end


