class ItemsPage < BasePage
  def initialize mode, url = nil
    @mode = mode
    @url = url
  end

  def items
    case @mode
      when 'main' then
        page = HomePage.new

      when 'channels' then
        page = ChannelsPage.new
      when 'catalog' then
        page = CatalogPage.new
      when 'media' then
        page = MediaPage.new @url
      when 'search' then
        page = SearchPage.new @url
      when 'best_hundred' then
        page = BestHundredPage.new
      when 'top_this_week' then
        page = TopThisWeekPage.new
      when 'premiere' then
        page = PremierePage.new
      when 'new_items' then
        page = NewItemsPage.new
      when 'audio' then
        page = AudioPage.new
      when 'radio' then
        page = RadioPage.new
      else
        page = nil
    end

    page.nil? ? [] : page.items
  end

end