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

    #list.delete_at(0)

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

    document.css("table tr td .navigation").each do |item|
      text = item.children.at(0).content
      href = item['href']
      record = MediaItem.new(text, href)
      unless list.include? record
#        unless href =~ /forum.etvnet.ca/ or href =~ /help.html/ or href =~ /contacts.html/ or
#               href =~ /eitv_browse.fcgi/ or href =~ /login.fcgi/ or href =~ /eitv_signup3.cgi/
          list << record
#        end
      end
    end

    list
  end

  def category_breadcrumbs
    list = []

    document.css("table tr[2] td table tr[2] td table tr[1] td[1]").each do |item|
      item.children.each do |breadcrumb|
        record = {}

        if breadcrumb.text.strip.size > 0
          record[:text] = breadcrumb.text
        end

        if breadcrumb.element?
          href = breadcrumb.attributes['href']

          if href.respond_to? :value
            record[:link] = breadcrumb.attributes['href'].value
          end
        end

        list << record if record.size > 0
      end
    end

    list
  end

  def categories
    list = []

    document.css("table tr[2] td table tr td table tr td").each_with_index do |item1, index1|
      if index1 > 0
        item1.css("a").each do |item2|
          link = item2.attributes['href'].value

          if link =~ /category/
            record = { :text => item2.text,  :link => link }

            additional_info = additional_info(item2, 2)

            record[:additional_info] = additional_info unless additional_info.nil?

            list << record
          end
        end
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
