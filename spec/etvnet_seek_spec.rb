$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'

require 'rubygems'
require 'spec'

require 'etvnet_seek'

describe EtvnetSeek do

  before :each do
    @client = EtvnetSeek.new
  end

  it "should return search menu items" do
    keywords = "красная шапочка"

    @client.search(keywords).size.should > 0
    items = @client.search(keywords)
    @client.display_search_items items
  end

  it "should return single search item" do
    keywords = "красная шапочка"

    result = @client.search(keywords)

    result.each do |item|
      #item.class.should == Hash if item[:]
    end
  end
end
