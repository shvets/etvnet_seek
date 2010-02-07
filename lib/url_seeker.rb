require 'nokogiri'
require 'open-uri'
require 'cgi'
require 'json'

class UrlSeeker

  def search url
    doc = Nokogiri::HTML(open(url))

    list = []

    doc.css("table tr[2] td table").each do |item|
      links = item.css(".media_file")

      links.each_with_index do |link, index|
        if index % 2 != 0
          href = link.attributes['href'].value

          new_link = list.select {|l| l[:link] == href}.empty?

          if new_link
            record = {:link => href,
                      :name => link.content.strip,
  #                    :first_time => link.parent.parent.previous.previous.previous.previous.content.strip,
  #                    :year => link.parent.parent.next.next.content.strip,
  #                    :how_long => link.parent.parent.next.next.next.next.content.strip
            }

            if href =~ /action=browse_container/
              record[:container] = search(href)
            else
              result = href.match(/(\w*)\/(\w*)\/(\w*)\/([\w|-]*)/)

              record[:media_file] = (result.size > 2) ? result[3] : ""
              record[:english_name] = (result.size > 3) ? result[4] : ""
            end

            list << record
          end
        end
      end
    end

    list
  end

  def display_results items
    items.each_with_index do |item1, index1|

      if item1[:container].nil?
        puts "#{index1+1}. #{item1[:english_name]} --- #{item1[:media_file]} --- #{item1[:name]}"
      else
        puts "#{index1+1}. #{item1[:name]}"

        item1[:container].each_with_index do |item2, index2|
          puts "    #{index1+1}.#{index2+1}. #{item2[:english_name]} --- #{item2[:media_file]} --- #{item2[:name]}"
        end
      end
    end
  end

  def grab_movie_link link, cookie, url
    result = link.match(/(\w*)\/(\w*)\/(\w*)\/([\w|-]*)/)

    media_file = (not result.nil? and result.size > 2) ? result[3] : ""

    media_info = request_media_info media_file, cookie, url

    mms_link(media_info)
  end
  
  private

  def request_media_info media_file, cookie, url
    url = URI.parse(url)
    conn = Net::HTTP.new(url.host, url.port)
    
    headers = { 'Cookie' => cookie }
  
    request = Net::HTTP::Post.new(url.request_uri, headers)
  
    request.set_form_data(
      { 'action' => 'start_video', 'bitrate' => '600',
        'media_file'=> media_file, 'replay' => '1', 'skin' => 'JSON'
      }
    )
  
    response = conn.request(request)
  
    response.body
  end

  def mms_link media_info
    JSON.parse(media_info)["PARAMETERS"]["REDIRECT_URL"]
  end
end