require 'open-uri'

class ServiceCall
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def get
    open(url, "User-Agent" => "Ruby/#{RUBY_VERSION}")
  end

  def post params, headers
    request = Net::HTTP::Post.new(url, headers.merge({"User-Agent" => "Ruby/#{RUBY_VERSION}"}))
    request.set_form_data(params)
    #request.basic_auth(un, pw)
    #"Content-Type"=>"application/x-www-form-urlencoded",
    #"Authorization" => "Basic " + Base64::encode64("account:password")
    response = request(request, url)

    if response.class == Net::HTTPMovedPermanently
      response = handle_redirect response['location'], params, headers
    end

    response
  end

  protected

  def handle_redirect url, params, headers
    request = Net::HTTP::Post.new(url, headers.merge({"User-Agent" => "Ruby/#{RUBY_VERSION}"}))
    request.set_form_data(params)

    request(request, url)
  end

  def request request, url
    uri = URI.parse(url)

    connection = Net::HTTP.new(uri.host, uri.port)

    connection.request(request)
  end
  
end