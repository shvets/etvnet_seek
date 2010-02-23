require 'open-uri'

class ServiceCall
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def get
    open(url)
  end

  def post params, headers
    request = Net::HTTP::Post.new(url, headers)

    request.set_form_data(params)

    request(request)
  end

  protected

  def request request
    uri = URI.parse(url)

    connection = Net::HTTP.new(uri.host, uri.port)

    connection.request(request)
  end
  
end