require 'page/base_page'

class MainPage < BasePage

  def items
    list = []

    document.css("#tblCategories a").each do |item|
      text = item.css("img").at(0).attributes['alt'].value
      href = item['href']

       unless href =~ /forum.etvnet.ca/ or href =~ /action=browse_persons/ or href =~ /valentines2010/
        list << MediaItem.new(text, href)
         end
    end

    list.delete_at(0)

    list
  end

end