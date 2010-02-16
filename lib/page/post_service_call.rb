class PostServiceCall
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def response request
    uri = URI.parse(url)
    connection = Net::HTTP.new(uri.host, uri.port)

    headers = { "Content-Type" => "application/x-www-form-urlencoded" }
    connection.post(uri.path, request, headers)
  end
end
