require 'etvnet_seek/core/page'
require 'etvnet_seek/core/media_item'

class ItemsPage < Page
  def items
    []
  end

  def title
    document.css("title").text
  end

  def page_title
    document.css(".conteiner h1").text
  end

  def navigation_menu
    list = collect_links "#nav"

    list.select { |element| not element =~ /(press|register|persons)/}
  end

  def category_breadcrumbs
    collect_links ".info_menu-onecolumn .path_movie_menu"
  end

  def categories
    list = []

    document.css(".movie_menu-onecolumn ul li").each do |item|
      href = item.css("a").at(0).attributes['href'].value
      text = item.css("a").at(0).text
      additional_info = item.css("span.small-text-movie-menu")

      list << MediaItem.new(text, href, additional_info)
    end

    list
  end

  def title_items
    list = []

    document.css("#table-onecolumn th").each do |item|
      link = item.css("a").at(0)

      if link
        href = link.attributes['href'].value
        text = link.text
      else
        href = nil
        text = item.text
      end

      list << MediaItem.new(text, href)
    end

    list
  end

  def see_too_items
    collect_links ".description .all_next_prev_movie ul li"
  end

  def page_browser
    node = document.css(".paging .holder").first

    node.nil? ? nil : node.inner_html
  end

  def description
    document.css(".description-container").inner_html
  end

  protected

  def collect_links path
    list = []

    document.css("#{path} a").each do |item|
      href = item.attributes['href'].value
      text = item.text

      list << MediaItem.new(text, href)
    end

    list
  end

  def collect_images path
    list = []

    document.css("#{path} img").each do |item|
      list << item.attributes['src'].value.strip
    end

    list
  end

  def additional_info node, index
    children = node.parent.children
    if children.size > 0
      element = children.at(index)
      element.text if element
    end
  end
end
