class SearchPage < MediaPage
  SEARCH_URL = BASE_URL + "/cgi-bin/video/eitv_browse.fcgi?action=search"

  def initialize(params)
    super("#{SEARCH_URL}&keywords=#{CGI.escape(*params)}&order_direction=-")
  end
end
