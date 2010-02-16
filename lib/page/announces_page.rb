require 'page/page'

class AnnouncesPage < Page
  def items
    list = []

    document.css("table tr td div").each do |item|
      unless item.css("a").at(0).nil?
        text = item.css("img").at(0).attributes['alt'].value.strip
        href = item.css("a").at(0).attributes['href'].value

        list << BrowseMediaItem.new(text, href)
      end
    end

    list
  end
end
