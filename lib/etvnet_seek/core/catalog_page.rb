class CatalogPage < ItemsPage
  CATALOG_URL = BASE_URL + "/catalog/"

  def initialize url = CATALOG_URL
    super(url)
  end

  def items
    list = []

    document.css(".conteiner #results #table-onecolumn tr").each_with_index do |item, index|
      next if index == 0

      showtime = item.css("td[1]").text.strip
      rating_image = item.css("td[3] img").at(0) ? item.css("td[3] img").at(0).attributes['src'].value.strip : ""
      rating = item.css("td[4]") ? item.css("td[4]").text.strip : ""
      name = item.css("td[2]").text.strip
      duration = item.css("td[5]") ? item.css("td[5]").text.strip : ""
      link = item.css("td[2] a").at(0)

      unless link.nil?
        href = link.attributes['href'].value
        digit_scan = name.scan(/\((\d*).*\)/)[0]
        amount_expr = digit_scan.nil? ? 0 : digit_scan[0].to_i
        folder = (amount_expr > 1) ? true : false

        record = BrowseMediaItem.new(name, href)
        record.folder = folder
        record.showtime = showtime
        record.duration = duration
        record.rating_image = rating_image
        record.rating = rating

        list << record
      end
    end

    list
  end

end
