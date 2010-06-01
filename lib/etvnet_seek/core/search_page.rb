require 'cgi'

class SearchPage < Page
  SEARCH_URL = BASE_URL + "/search/"

  def initialize(params)
    super("#{SEARCH_URL}?q=#{CGI.escape(*params)}")
  end

  def items
    list = []

    document.css(".conteiner #results #table-onecolumn tr").each_with_index do |item, index|
      next if index == 0
      
      showtime = item.css("td[1]").text.strip
      rating_image = item.css("td[2] img").at(0) ? item.css("td[2] img").at(0).attributes['src'].value.strip : ""
      rating = item.css("td[3]") ? item.css("td[3]").text.strip : ""
      name = item.css("td[4]").text.strip
      duration = item.css("td[5]") ? item.css("td[5]").text.strip : ""
      link = item.css("td[4] a").at(0)

      href = link.attributes['href'].value

      amount_expr = name.scan(%r{(.*)+\((\d*)+ (.*)+\)})[0]

      folder = (not amount_expr.nil? and amount_expr.size > 1) ? true : false

      record = BrowseMediaItem.new(name, href)
      record.folder = folder
      record.showtime = showtime
      record.duration = duration
      #record.channel = channel
      record.rating_image = rating_image
      record.rating = rating

      list << record
    end

    list
  end
end
