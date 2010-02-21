require 'page/search_page'
require 'page/media_page'
require 'page/base_page'
require 'page/channels_page'
require 'page/group_page'
require 'page/announces_page'
require 'page/freetv_page'

class PageFactory
  def self.create mode, params = []
    url = (mode == 'search') ? nil : (params.class == String ? params : params[0])

    case mode
      when 'search' then
        SearchPage.new *params
      when 'main' then
        BasePage.new
      when 'channels' then
        ChannelsPage.new
      when 'best_ten' then
        BestTenPage.new
      when 'popular' then
        PopularPage.new
      when 'we_recommend' then
        WeRecommendPage.new
      when 'announces' then
        AnnouncesPage.new url
      when 'freetv' then
        FreetvPage.new url
      when 'media' then
        MediaPage.new url
      when 'access' then
        AccessPage.new
      when 'login' then
        LoginPage.new
      else
        nil
    end
  end
end
