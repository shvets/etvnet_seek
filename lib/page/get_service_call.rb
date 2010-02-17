require 'open-uri'

class GetServiceCall
  attr_reader :url, :uri

  def initialize(url)
    @url = url
    @uri = URI.parse(url)
  end

  def response
    open(url)
  end

  def response_low_level request
    connection = Net::HTTP.new(uri.host, uri.port)

    connection.request(request)
  end
end