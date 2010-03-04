class ArchiveMediaPage < BasePage
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
        showtime = tr.css("td[1]").text.strip
        rating_image = tr.css("td[2] img").at(0) ? tr.css("td[2] img").at(0).attributes['src'].value.strip : ""
        rating = tr.css("td[3]").text.strip

        year = tr.css("td[6]") ? tr.css("td[6]").text.strip : ""
        duration = tr.css("td[7]").text.strip ? tr.css("td[7]").text.strip : ""
        channel = tr.css("td[8]") ? tr.css("td[8]").text.strip : ""

        if link =~ /action=browse_container/
          folder = true
          link = link[Page::BASE_URL.size..link.size]
        else
          folder = false
        end

        record = ArchiveMediaItem.new(text, link)
        record.folder = folder
        record.rating_image = rating_image
        record.rating = rating
        record.showtime = showtime
        record.duration = duration
        record.year = year
        record.channel = channel

        list << record
      end
    end

    list
  end

end


