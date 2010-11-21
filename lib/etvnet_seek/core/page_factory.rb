require 'etvnet_seek/core/media_item'
require 'etvnet_seek/core/new_item'
require 'etvnet_seek/core/catalog_item'
require 'etvnet_seek/core/media_info'
require 'etvnet_seek/core/browse_media_item'
require 'etvnet_seek/core/channel_media_item'
require 'etvnet_seek/core/group_media_item'

require 'etvnet_seek/core/service_call'
require 'etvnet_seek/core/page'
require 'etvnet_seek/core/home_page'
require 'etvnet_seek/core/base_page'
require 'etvnet_seek/core/media_page'
require 'etvnet_seek/core/search_page'
require 'etvnet_seek/core/channels_page'
require 'etvnet_seek/core/catalog_page'
require 'etvnet_seek/core/audio_page'
require 'etvnet_seek/core/radio_page'
require 'etvnet_seek/core/new_items_page'
require 'etvnet_seek/core/group_page'
require 'etvnet_seek/core/access_page'
require 'etvnet_seek/core/login_page'

class PageFactory
  def self.create mode, params = []
    url = (mode == 'search') ? nil : (params.class == String ? params : params[0])

    case mode
      when 'search' then
        SearchPage.new *params
      when 'main' then
        HomePage.new
      when 'channels' then
        ChannelsPage.new
       when 'catalog' then
        CatalogPage.new
      when 'best_hundred' then
        BestHundredPage.new
      when 'new_items' then
        NewItemsPage.new
      when 'premiere' then
        PremierePage.new    
      when 'media' then
        MediaPage.new url
      when 'audio' then
        AudioPage.new url
      when 'radio' then
        RadioPage.new
      when 'access' then
        AccessPage.new
      when 'login' then
        LoginPage.new
      else
        nil
    end
  end
end
