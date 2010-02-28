require 'nokogiri'

class Page < ServiceCall
  BASE_URL = "http://www.etvnet.ca"

  attr_reader :document

  def initialize(url = BASE_URL)
    super(url.index(BASE_URL).nil? ? "#{BASE_URL}/#{url}" : url)

    @document = get_document
  end

  protected

  def get_document
    Nokogiri::HTML(get)
  end
end
