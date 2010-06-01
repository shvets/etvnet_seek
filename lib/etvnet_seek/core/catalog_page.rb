class CatalogPage < MediaPage
  CATALOG_URL = BASE_URL + "/catalog/"

  def initialize url = CATALOG_URL
    super(url)
  end

  def items
    list = []

    document.css("#table-onecolumn tr").each do |item|
      links = item.css("td a")

      href = links[0]
      catalog_href = links[1]

      link = href.attributes['href'].value
      text = href.attributes['title'].value
      catalog_link = catalog_href.attributes['href'].value

      item = CatalogItem.new(text, link, catalog_link)

      list << item
    end

    list
  end

end
