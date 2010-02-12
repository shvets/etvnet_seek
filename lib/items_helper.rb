require 'media_item'

module ItemsHelper
  def get_menu_items url
    doc = Nokogiri::HTML(open(url))

    list = []

    doc.css("b a.media_file").each do |item|

      href = item.attributes['href'].value
      new_link = list.select {|l| l.link == href}.empty?

      if new_link
        list << create_new_media_item(item, href) if new_link
      end
    end

    list
  end

  def create_new_media_item link, href
    record = MediaItem.new(link.content.strip, href)
    
    record.first_time = link.parent.parent.parent.css('td[1]').text.strip
    record.year = link.parent.parent.next.next.content.strip

    if href =~ /action=browse_container/
      record.container = get_menu_items(href)
    else
      record.media_file = media_file(href)
      record.english_name = english_name(href)
      record.how_long = link.parent.parent.next.next.next.next.content.strip unless
        link.parent.parent.next.next.next.next.nil?
    end

    record
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
          today_link = links[0]

          unless today_link.nil?
            record.today_link = today_link.attributes['href'].value
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

  def get_today_items url
    doc = Nokogiri::HTML(open(url))

    list = []

#    doc.css("table tr[2] td table tr td table tr[2] td[2] table tr").each do |item|
    doc.css("table tr[2] td table").each do |item|
      links = item.css(".media_file")

      links.each_with_index do |link, index|
        if index % 2 != 0
          record = MediaItem.new(link.content.strip, link.attributes['href'].value)
          record.first_time = link.parent.parent.previous.previous.previous.previous.content.strip,
          record.year = link.parent.parent.next.next.content.strip,
          record.how_long = link.parent.parent.next.next.next.next.content.strip

          list << record
        end
      end
    end

    list
  end

  def get_archive_items url
    doc = Nokogiri::HTML(open(url))
    
    list = []

    doc.xpath(items_url).each_with_index do |item1, index1|
      if index1 > 0
        record = MediaItem.new("", "")

        record.showtime = ""
        record.stars = ""
        record.rating = ""
        record.info_link = ""
        record.year = ""
        record.duration = ""
        record.channel = ""

        item1.children.each_with_index do |item2, index2|
          case index2
            when 0 then
              record.showtime = item2.children.at(0).content.strip
            when 2 then
              src = item2.children.at(0).attributes['src']
              record.stars = src.value if not src.nil?
            when 4 then
              record.rating = item2.children.at(0).content.to_i
            when 6 then
              record.info_link = item2.children.at(1)["href"]
            when 10 then
              record.year = item2.children.at(0).content.strip
            when 12 then
              record.duration = item2.children.at(0).content.strip
            when 14 then
              record.channel = item2.children.at(0).content.strip
          end
        end

        unless list.include? record
          list << record
        end
      end
    end

    list
  end

  private

  def get_typical_items doc, tag_name
    list = []

    doc.css(tag_name).at(0).next.children.each do |table|
      link = table.css("a").at(0)

      unless link.nil?

        href = link.attributes['href'].value

        record = MediaItem.new(link.children.at(0).content, href)

        if href =~ /media/
          record.media_file = media_file(href)
          record.english_name = english_name(href)

          additional_info = additional_info(link, 1)

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

  def media_file href
    result = href.match(/(\w*)\/(\w*)\/(\w*)\/([\w|-]*)/)

    (result.size > 2) ? result[3] : ""
  end

  def english_name href
    result = href.match(/(\w*)\/(\w*)\/(\w*)\/([\w|-]*)/)

    (result.size > 3) ? result[4] : ""
  end

end