$LOAD_PATH.unshift File.dirname(__FILE__) + '/lib'

require 'rubygems' unless RUBY_VERSION =~ /1.9.*/

require 'spec_helper'

require 'etvnet_seek/etvnet_seek'
require 'etvnet_seek/main'
require 'runglish'

describe Main do

  it "should return search menu items" do
    keywords = "красная шапочка"

    page = ItemsPageFactory.create "search", keywords

    page.items.size.should > 0

    p page.items
  end

end

describe Runglish do
  it "should return translation" do
    Runglish::RusToLatConverter.new.transliterate("как дела?").should == "kak dela?"
    Runglish::LatToRusConverter.new.transliterate("krasnaya shapochka").should == "красная шапочка"
  end
end
