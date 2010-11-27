require 'etvnet_seek/core/home_page'
require 'etvnet_seek/core/channels_page'
require 'etvnet_seek/core/catalog_page'
require 'etvnet_seek/core/media_page'
require 'etvnet_seek/core/search_page'
require 'etvnet_seek/core/best_hundred_page'
require 'etvnet_seek/core/top_this_week_page'
require 'etvnet_seek/core/premiere_page'
require 'etvnet_seek/core/new_items_page'
require 'etvnet_seek/core/audio_page'
require 'etvnet_seek/core/radio_page'

class ItemsPageFactory
  def self.create mode, params = []
    url = (mode == 'search') ? nil : (params.class == String ? params : params[0])

    case mode
      when 'main' then
        page = HomePage.new
      when 'channels' then
        page = ChannelsPage.new
      when 'catalog' then
        page = CatalogPage.new
      when 'media' then
        page = MediaPage.new url
      when 'search' then
        page = SearchPage.new *params
      when 'best_hundred' then
        page = BestHundredPage.new
      when 'top_this_week' then
        page = TopThisWeekPage.new
      when 'premiere' then
        page = PremierePage.new
      when 'new_items' then
        page = NewItemsPage.new
      when 'audio' then
        page = AudioPage.new url
      when 'radio' then
        page = RadioPage.new
      else
        page = nil
    end

    page
  end

end
