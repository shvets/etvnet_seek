$LOAD_PATH.unshift File.dirname(__FILE__) + '/lib'

require 'rubygems' unless RUBY_VERSION =~ /1.9.*/

require 'etvnet_seek/etvnet_seek'
require 'etvnet_seek/main'
require 'runglish'

describe Main do

  before :each do
    @client = Main.new
  end

  it "should return search menu items" do
    commander = @client.instance_variable_get(:@commander)
    commander.instance_variable_set(:@options, {:search => true})
    
    keywords = "красная шапочка"

    items = @client.seek(keywords)

    @client.display_items items
  end

end

describe Runglish do
  it "should return translation" do
    Runglish::RusToLatConverter.new.transliterate("как дела?").should == "kak dela?"
    Runglish::LatToRusConverter.new.transliterate("krasnaya shapochka").should == "красная шапочка"
  end
end
