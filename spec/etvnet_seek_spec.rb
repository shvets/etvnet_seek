$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'

require 'rubygems' unless RUBY_VERSION =~ /1.9.*/

require 'main'
require 'url_seeker'
require 'runglish'

describe UrlSeeker do

  before :each do
    @client = UrlSeeker.new(Main::SEARCH_URL, Main::ACCESS_URL)
  end

  it "should return search menu items" do
    keywords = "красная шапочка"

    items = @client.search(keywords)
    @client.display_results items
  end

end

describe Runglish do
  it "should return translation" do
    Runglish.new.ru_to_lat("как дела?").should == "kak dela?"
    Runglish.new.lat_to_ru("krasnaya shapochka").should == "красная шапочка"
  end
end
