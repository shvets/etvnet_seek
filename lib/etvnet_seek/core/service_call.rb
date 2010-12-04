require 'open-uri'

require 'net/http'

# Lengthen timeout in Net::HTTP
module Net
  class HTTP
    alias old_initialize initialize

    def initialize(*args)
      old_initialize(*args)
      @read_timeout = 3*60 # 3 minutes
    end
  end
end

class ServiceCall
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def get
    open(url, "User-Agent" => "Ruby/#{RUBY_VERSION}")
  end

  def post params, headers, url = @url
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