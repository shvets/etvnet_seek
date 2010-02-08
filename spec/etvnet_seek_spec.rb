$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'

require 'rubygems' unless RUBY_VERSION =~ /1.9.*/

#require 'spec'

require 'main'
require 'url_seeker'
require 'runglish'

describe UrlSeeker do

  before :each do
    @client = UrlSeeker.new
  end

  it "should return search menu items" do
    keywords = "красная шапочка"

    #@client.search(keywords).size.should > 0

    items = @client.search(Main.search_url(keywords))
    @client.display_results items
  end

end

describe Runglish do
  it "should return translation" do
    #Runglish.new.translate("kak dela?").size.should > 0
    p Runglish.new.ru_to_lat("как дела?")
    p Runglish.new.lat_to_ru("krasnaya shapochka")
  end
end
