require 'media_item'

module ItemsHelper
  def get_menu_items url
    doc = Nokogiri::HTML(open(url))

    list = []

    doc.css("b a.media_file").each do |item|
      link = item.attributes['href'].value
      new_link = list.select {|l| l.link == link}.empty?

      if new_link
        record = BrowseMediaItem.new(item.content.strip, link)

        record.showtime = item.parent.parent.parent.css('td[1]').text.strip
        record.year = item.parent.parent.next.next.content.strip

        if link =~ /action=browse_container/
          record.container = get_menu_items(link)
        else
          record.duration = item.parent.parent.next.next.next.next.content.strip unless
            item.parent.parent.next.next.next.next.nil?
        end

        list << record
      end
    end

    list
  end

#  def get_today_items url
#    doc = Nokogiri::HTML(open(url))
#
#    list = []
#
##    doc.css("table tr[2] td table tr td table tr[2] td[2] table tr").each do |item|
#    doc.css("table tr[2] td table").each do |item|
#      links = item.css(".media_file")
#
#      links.each_with_index do |link, index|
#        if index % 2 != 0
#          record = MediaItem.new(link.content.strip, link.attributes['href'].value)
#          record.showtime = link.parent.parent.previous.previous.previous.previous.content.strip,
#          record.year = link.parent.parent.next.next.content.strip,
#          record.duration = link.parent.parent.next.next.next.next.content.strip
#
#          list << record
#        end
#      end
#    end
#
#    list
#  end

#  def get_archive_items url
#    doc = Nokogiri::HTML(open(url))
#
#    list = []
#
#    root = "/html/body/table[1]/tr[2]/td[1]/table[1]/tr[3]/td[1]/table[1]/tr[2]/td[2]/table[1]/tr"
#    p "1"
#    doc.xpath(root).each_with_index do |item1, index1|
#      p item1
##      if index1 > 0
##        record = MediaItem.new("", "")
##
##        record.showtime = ""
##        record.stars = ""
##        record.rating = ""
##        record.info_link = ""
##        record.year = ""
##        record.duration = ""
##        record.channel = ""
##
##        item1.children.each_with_index do |item2, index2|
##          case index2
##            when 0 then
##              record.showtime = item2.children.at(0).content.strip
##            when 2 then
##              src = item2.children.at(0).attributes['src']
##              record.stars = src.value if not src.nil?
##            when 4 then
##              record.rating = item2.children.at(0).content.to_i
##            when 6 then
##              record.info_link = item2.children.at(1)["href"]
##            when 10 then
##              record.year = item2.children.at(0).content.strip
##            when 12 then
##              record.duration = item2.children.at(0).content.strip
##            when 14 then
##              record.channel = item2.children.at(0).content.strip
##          end
##        end
##
##        unless list.include? record
##          list << record
##        end
##      end
#    end
#
#    list
#  end

  def get_announce_items url
    doc = Nokogiri::HTML(open(url))

    list = []

    i = 0
    doc.css("table tr td div").each do |item|
      unless item.css("a").at(0).nil?
        list << { :text => item.css("img").at(0).attributes['alt'].value.strip,
                  :link =>  item.css("a").at(0).attributes['href'].value}
      end
    end

    list
  end

  def get_freetv_items url
    doc = Nokogiri::HTML(open(url))

    list = []

    doc.css("table tr td table tr td table tr td div table tr").each_with_index do |item, index|
      #next if index < 1
      node = item.css("td img")
      if node.size > 0
        text = node.at(0).parent.css("a")
        unless text.to_s.size == 0
          link = node.at(0).parent.css("a")
          record = { :text => link.at(0).text,
                     :link => link.at(0).attributes['href'].value.strip,
                     :rating_image => node.at(0).attributes['src'] }

          list << record
        end
      end
    end

    list
  end
  
  def get_main_menu_items url
    doc = Nokogiri::HTML(open(url))

    list = []

    doc.css("#tblCategories a").each do |item|
      text = item.css("img").at(0).attributes['alt'].value
      href = item['href']

      list << MediaItem.new(text, href)
    end

    list.delete_at(0)

    list
  end

  def get_best_ten_items url
    doc = Nokogiri::HTML(open(url))

    get_typical_items(doc, "#tbl10best")
  end

  def get_popular_items url
    doc = Nokogiri::HTML(open(url))

    get_typical_items(doc, "#tblyearago")
  end

  def get_we_recommend_items url
    doc = Nokogiri::HTML(open(url))

    items = get_typical_items(doc, "#tblfree")

    more_recommended_item = items.delete_at(items.size-1)

    more_recommended_items = get_menu_items(UrlSeeker::BASE_URL + more_recommended_item.link)
    
    items.concat more_recommended_items
  end

  def get_channel_items url
    doc = Nokogiri::HTML(open(url))

    list = []

    doc.css("table table table.rounded_white table tr").each_with_index do |item, index|
      links = item.css("table tr td a")

      text = item.children.at(0).text.strip

      if text.size > 0
        record = ChannelMediaItem.new(text)

        if links.size > 0
          link = links[0]

          unless link.nil?
            record.link = link.attributes['href'].value
          end

          archive_link = links[1]

          unless archive_link.nil?
            record.archive_link = archive_link.attributes['href'].value
          end
        end

        list << record
      end
    end

    list
  end

  private

  def get_typical_items doc, tag_name
    list = []

    doc.css(tag_name).at(0).next.children.each do |table|
      href = table.css("a").at(0)

      unless href.nil?
        link = href.attributes['href'].value

        record = BrowseMediaItem.new(href.children.at(0).content, link)

        if link =~ /media/
          additional_info = additional_info(href, 1)

          record.text += additional_info unless additional_info.nil?
        end

        list << record
      end
    end

    list
  end

  def additional_info node, index
    children = node.parent.children
    if children.size > 0
      children.at(index)
    else
      nil
    end
  end

end