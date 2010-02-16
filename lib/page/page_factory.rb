require 'page/search_page'
require 'page/media_page'
require 'page/base_page'
require 'page/channels_page'
require 'page/group_page'
require 'page/announces_page'
require 'page/freetv_page'

class PageFactory
  def self.create mode, params = []
    url = (mode == 'search') ? nil : params[0]

    case mode
      when 'search' then
        page = SearchPage.new *params
      when 'folder' then
        page = MediaPage.new url
      when 'main' then
        page = BasePage.new
      when 'channels' then
        page = ChannelsPage.new
      when 'best_ten' then
        page = BestTenPage.new
      when 'popular' then
        page = PopularPage.new
      when 'we_recommend' then
        page = WeRecommendPage.new
      when 'today' then
        page = MediaPage.new url
      when 'archive' then
        page = MediaPage.new url
      when 'announces' then
        page = AnnouncesPage.new url
      when 'freetv' then
        page = FreetvPage.new url
      when 'category' then
        page = MediaPage.new url
      when 'media ' then
        page = MediaPage.new url
      else
        page = nil
    end

    page
  end
end
