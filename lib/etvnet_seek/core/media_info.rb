require 'json'

class MediaInfo
  attr_reader :name, :link, :description, :description_production, :rtsp_link, :speech_lang,
              :file_length, :channel, :datetime, :popularity, :duration, :rating

  def initialize params
    @link = params["REDIRECT_URL"]
    @session_expired = (params["error_session_expire"] == 1)
    @description_production = params["description_production"]
    @rtsp_link = params["REDIRECT_URL_RTSP"]
    @speech_lang = params["speech_lang"]
    @name = params["name"]
    @description = params["description"]
    @file_length = params["file_length"]
    @channel = params["channel"]
    @datetime = params["datetime"]
    @popularity = params["popularity_24h"]
    @duration = params["duration"]
    @rating = params["rating"]
  end

  def resolved?
    not @link.nil? and not @link.strip.size == 0
  end

  def session_expired?
    @session_expired
  end
end

