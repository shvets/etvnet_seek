require 'page/base_page'

class MediaPage < BasePage
  def items
    list = []

    document.css("b a.media_file").each do |item|
      link = item.attributes['href'].value
      new_link = list.select {|l| l.link == link}.empty?

      if new_link
        text = item.content.strip
        showtime = item.parent.parent.parent.css('td[1]').text.strip
        year = item.parent.parent.next.next.content.strip

        if link =~ /action=browse_container/
          folder = true
          link = link[Page::BASE_URL.size..link.size]
          duration = ""
        else
          folder = false
          duration = item.parent.parent.next.next.next.next.content.strip unless
            item.parent.parent.next.next.next.next.nil?
  #        record.stars = ""
  #        record.rating = ""
        end

        record = BrowseMediaItem.new(text, link)
        record.folder = folder
        record.showtime = showtime
        record.year = year
        record.duration = duration

        list << record
      end
    end

    list
  end

  def item_titles
    list = []

    #doc.css("table tr[2] td table tr td table tr[2] td[2] table").each_with_index do |item1, index1|
    doc.css("table tr[2] td table tr td table tr[2] td[2] table").each_with_index do |item1, index1|

      if index1 == 1
        item1.css("tr[1] td").each do |item2|
          node = item2.children.at(0)
          text = node.text.strip

          if node.text? and not text.size == 0
             list << {:text => text}
          elsif node.element? and not text.size == 0
             list << {:text => text, :link => node.attributes['href'].value }
          end
        end
      end
    end

    list
  end  

end



#class ArchivePage < BasePage
#
#  PAGE_ROOT = "/html/body/table[1]/tr[2]/td[1]/table[1]"
#
#  def group_menu_url
#    "#{PAGE_ROOT}/tr[2]/td[1]/table[1]/tr[2]/td[2]/table[1]/tr/td/a"
#  end
#
#  def title_menu_url
#    "#{PAGE_ROOT}/tr[3]/td[1]/table[1]/tr[2]/td[2]/table[1]/tr[1]/td"
#  end
#
#  def items_url
#    "#{PAGE_ROOT}/tr[3]/td[1]/table[1]/tr[2]/td[2]/table[1]/tr"
#  end
#
#  def page_menu_url
#    "#{PAGE_ROOT}/tr[4]/td[1]"
#  end
#
#  def group_menu
#    collect_links(group_menu_url)
#  end
#
#  def title_menu
#    list = []
#
#    doc.xpath(title_menu_url).each do |item|
#      if item.children.size > 0
#        if item.children.size == 1
#          add_record(list, { :text => item.content.strip })
#        else
#          link = item.children.at(1).children.at(0).children.at(0).children.at(0)
#          item.children.each do |item1|
#            item1.children.each do |item2|
#              item2.children.each do |item3|
#                link = item3.xpath("a")
#
#                if link.size > 0
#                  if link.size == 1
#                    add_record(list, { :text => link.at(0).content.strip, :link => link.at(0)['href'] })
#                  else
#                    item3.children.each do |item4|
#                      if item4.kind_of? Nokogiri::XML::Element
#                        add_record(list, { :text => item4.content.strip, :link => item4.attributes['href'] })
#                      end
#                    end
#                  end
#                end
#              end
#            end
#          end
#        end
#      end
#    end
#
#    list
#  end
#
#  def items
#    list = []
#
#    doc.xpath(items_url).each_with_index do |item1, index1|
#      if index1 > 0
#        record = { :showtime => "", :stars => "", :rating => "", :info_link => "",
#                   :year => "", :duration => "", :channel => "" }
#
#        item1.children.each_with_index do |item2, index2|
#          case index2
#            when 0 then
#              record[:showtime] = item2.children.at(0).content.strip
#            when 2 then
#              src = item2.children.at(0).attributes['src']
#              record[:stars] = src.value if not src.nil?
#            when 4 then
#              record[:rating] = item2.children.at(0).content.to_i
#            when 6 then
#              record[:info_link] = item2.children.at(1)["href"]
#            when 10 then
#              record[:year] = item2.children.at(0).content.strip
#            when 12 then
#              record[:duration] = item2.children.at(0).content.strip
#            when 14 then
#              record[:channel] = item2.children.at(0).content.strip
#          end
#        end
#
#        add_record(list, record)
#      end
#    end
#
#    list
#  end
#
#  def page_menu
#    list = []
#
#    root = "#{PAGE_ROOT}/tr[4]/td[1]"
#
#    add_record(list, :title => doc.xpath(root).children.at(0).content.strip)
#
#    browser = doc.xpath(root).css(".browser")
#
#    add_record(list, browser.css("b").children.at(0).content => "")
#
#    browser.css("a").each do |link|
#      add_record(list, link.children.at(0).content => link["href"])
#    end
#
#    list
#  end
#
#  private
#
#  def add_record list, record
#    unless list.include? record
#      list << record
#    end
#  end
#
#  def collect_links path
#    list = []
#
#    doc.xpath(path).each do |item|
#      record = { :text => item.children.at(0).content, :link =>  item['href'] }
#
#      determine_amount(record, item.parent.content)
#
#      add_record(list, record)
#    end
#
#    list
#  end
#
#  def determine_amount record, content
#    amount_field = content.scan(/\(\d*\)/)
#
#    unless amount_field.nil? or amount_field.size == 0
#      record[:amount] = amount_field[0].gsub("(", "").gsub(")", "").to_i
#    end
#  end
#end
#

