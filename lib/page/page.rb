require 'nokogiri'

require 'page/get_service_call'

class Page < GetServiceCall
  BASE_URL = "http://www.etvnet.ca"

  attr_reader :document

  def initialize(url = BASE_URL)
    super(url.index(BASE_URL).nil? ? "#{BASE_URL}/#{url}" : url)

    @document = get_document
  end

  private

  def get_document
    Nokogiri::HTML(response)
  end
end
