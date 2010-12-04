#$LOAD_PATH.unshift File.dirname(__FILE__) + '/../../app/domain'

require 'rubygems' unless RUBY_VERSION =~ /1.9.*/

require 'etvnet_seek/core/home_page'

#require 'home_page'
#require 'announces_page'
#require 'freetv_page'
#require 'today_page'

#describe "base page" do
#  before :all do
#    @page = AnnouncesPage.new
#  end
#
#  it "should return navigation menu items" do
#    @page.navigation_menu.size.should > 0
#  end
#
#end

describe "home page" do
  before :all do
    @page = HomePage.new
  end

  it "should return main menu items" do
    @page.items.size.should > 0
  end

#  it "should return [best ten] items" do
#    @page.best_hundred.size.should > 0
#  end

#  it "should return [popular movies and serials] items" do
#    @page.popular_movies_and_serials.size.should > 0
#  end

#  it "should return [we recommend] items" do
#    @page.we_recommend.size.should > 0
#  end

end

#describe "announces page" do
#  before :all do
#    @page = AnnouncesPage.new
#  end
#
#  it "should return main menu items" do
#    @page.items.size.should > 0
#  end
#end

#describe "free TV page" do
#  before :all do
#    @page = FreetvPage.new
#  end
#
#  it "should return main menu items" do
#    @page.items.size.should > 0
#  end
#end
#
#describe "today page" do
#  before :all do
#    @page = TodayPage.new({:action => 'today', :channel => 1})
#  end
#
#  it "should return main menu items" do
#    @page.category_breadcrumbs.size.should > 0
#    @page.categories.size.should > 0
#    @page.items.size.should > 0
#  end
#end

