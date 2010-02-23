require 'open-uri'

class ServiceCall
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def get
    open(url)
  end

  def request params
    uri = URI.parse(url)
    connection = Net::HTTP.new(uri.host, uri.port)

    connection.request(params)
  end

  def post request
    uri = URI.parse(url)
    connection = Net::HTTP.new(uri.host, uri.port)

    headers = { "Content-Type" => "application/x-www-form-urlencoded" }
    connection.post(uri.path, request, headers)
  end
end