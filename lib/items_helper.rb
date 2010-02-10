require 'media_item'

module ItemsHelper
  def get_search_menu_items url
    doc = Nokogiri::HTML(open(url))

    list = []

    doc.css("table tr[2] td table").each do |item|
      links = item.css(".media_file")

      links.each_with_index do |link, index|
        if index % 2 != 0
          href = link.attributes['href'].value
          new_link = list.select {|l| l[:link] == href}.empty?

          if new_link
            record = MediaItem.new(link.content.strip, href)
            record.first_time = link.parent.parent.parent.css('td[1]').text.strip
            record.year = link.parent.parent.next.next.content.strip

            if href =~ /action=browse_container/
              record.container = get_search_menu_items(href)
            else
              record.media_file = media_file(href)
              record.english_name = english_name(href)
              record.how_long = link.parent.parent.next.next.next.next.content.strip unless
                link.parent.parent.next.next.next.next.nil?
            end

            list << record
          end
        end
      end
    end

    list
  end

  def media_file href
    result = href.match(/(\w*)\/(\w*)\/(\w*)\/([\w|-]*)/)

    (result.size > 2) ? result[3] : ""
  end

  def english_name href
    result = href.match(/(\w*)\/(\w*)\/(\w*)\/([\w|-]*)/)

    (result.size > 3) ? result[4] : ""
  end

  def get_main_menu_items url
    doc = Nokogiri::HTML(open(url))

    list = []

    doc.css("#tblCategories a").each do |item|
      list << { :text => item.css("img").at(0).attributes['alt'].value,
                :link => item['href']}
    end

    list.delete_at(0)

    list
  end

  def get_best_ten_items url
    doc = Nokogiri::HTML(open(url))

    get_typical_items(doc, "#tblyearago")
  end

  def get_popular_items url
    doc = Nokogiri::HTML(open(url))

    get_typical_items(doc, "#tbl10best")
  end

  def get_we_recommend url
    doc = Nokogiri::HTML(open(url))

    get_typical_items(doc, "#tblfree")
  end

  private

  def get_typical_items doc, tag_name
    list = []

    doc.css(tag_name).at(0).next.children.each do |table|
      link = table.css("a").at(0)

      unless link.nil?
        href = link.attributes['href'].value
        record = { :text => link.children.at(0).content, :link => href }

        record[:media_file] = media_file(href)
        record[:english_name] = english_name(href)

        additional_info = additional_info(link, 1)

        record[:text] += additional_info unless additional_info.nil?

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