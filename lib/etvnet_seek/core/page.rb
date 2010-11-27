require 'nokogiri'

require 'etvnet_seek/core/service_call'

class Page < ServiceCall
  BASE_URL = "http://www.etvnet.com"

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
