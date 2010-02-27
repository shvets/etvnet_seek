require 'page/page'
require 'media_item'

class BasePage < Page
  def items
    list = []

    document.css("#tblCategories a").each do |item|
      text = item.css("img").at(0).attributes['alt'].value
      href = item['href']

      list << MediaItem.new(text, href)
    end

    list
  end

  def title
    document.css("title").text
  end

  def page_title
    document.css(".global_content .global_content h1").text
  end

  def navigation_menu
    list = []

    document.css("table tr td .navigation").first.parent.parent.parent.css("tr td a").each do |item|
      text = item.children.at(0).content
      href = item['href']

      list <<  MediaItem.new(text, href) unless href =~ /(login|signup)/
    end

    list
  end

  def category_breadcrumbs
    list = []

    document.css("table tr td table tr td table tr td strong").each_with_index do |item, index|
      if index == 0
        item.children.each do |child|
          text = child.text
          link = child.attributes['href']
          href = link.nil? ? nil : link.value

          list << MediaItem.new(text, href)
        end
      end
    end

    list
  end

  def categories
    list = []

    document.css("table").each_with_index do |table1, index1|
      if index1 == 5
        table1.css("tr/td/table/tr/td/table").each_with_index do |table2, index2|
          if index2 == 2
            table2.css("tr[2]/td[2]/table").each_with_index do |table3, index3|

            #if index2 > 1
              table2.css("tr td a").each_with_index do |item2, index4|
                link = item2.attributes['href'].value

                #if link =~ /category/
                if index4 > 0
                  text = item2.text
                  href = link

                  additional_info = additional_info(item2, 2)

                  list << MediaItem.new(text, href, additional_info)
                end
              end
            end
          end
        end
      end
    end

    list
  end

  def title_items
    list = []

    root = nil
    document.css("a").each do |item|
      link = item.attributes['href']

      if link.value =~ /order_by/
        root = link.parent.parent.parent.parent.parent.parent
        break
      end
    end

    if root
      root.css("a").each do |item|
        link = item.attributes['href'].value

        text = item.text
        href = link

        list << MediaItem.new(text, href)
      end
    end

    list
  end

  protected

  def additional_info node, index
    children = node.parent.children
    if children.size > 0
      element = children.at(index)
      element.text if element
    end
  end
end
