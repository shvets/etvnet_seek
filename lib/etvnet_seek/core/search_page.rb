require 'cgi'

class SearchPage < CatalogPage
  SEARCH_URL = BASE_URL + "/search/"

  def initialize(params)
    super("#{SEARCH_URL}?q=#{CGI.escape(*params)}")
  end

end
