class MediaPage < BasePage
  def items
    list = []

    document.css(".conteiner table#table-onecolumn tr").each do |item|
      unless item.css("td[1]").text.empty?
        showtime = item.css("td[1]").text.strip
        name = item.css("td[2]").text.strip
        rating_image = item.css("td[3] img").at(0) ? item.css("td[3] img").at(0).attributes['src'].value.strip : ""
        rating = item.css("td[4]") ? item.css("td[4]").text.strip : ""
        duration = item.css("td[5]") ? item.css("td[5]").text.strip : ""
        year = item.css("td[6]") ? item.css("td[6]").text.strip : ""
        channel = item.css("td[7]") ? item.css("td[7]").text.strip : ""

        link = item.css("td[2] a").at(0).attributes['href'].value

        additional_info = additional_info(item.css("td[2] a").at(0), 2)

        folder = false

        if additional_info.strip.size > 0
          if(additional_info.strip.scan(/\((\d*)(.*)\)/)).size > 0
            folder = true
          end
        end

        record = BrowseMediaItem.new(name, link)
        record.folder = folder
        record.showtime = showtime
        record.year = year
        record.duration = duration
        record.channel = channel
        record.rating_image = rating_image
        record.rating = rating

        list << record
      end
    end

    list
  end

end


