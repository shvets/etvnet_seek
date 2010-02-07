$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'

require 'rubygems' unless RUBY_VERSION =~ /1.9.*/

#require 'spec'

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

end
