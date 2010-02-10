class MediaItem < Struct.new(:text, :link, :first_time, :year, :container, :media_file, :english_name, :how_long)

  def container?
    not self.container.nil?
  end

  def to_s
    buffer = "#{english_name}(#{media_file}) --- #{text}"

    buffer += " --- #{year}" if not year.nil? and year.size > 0
    buffer += " --- #{how_long}" if not how_long.nil? and how_long.size > 0

    buffer
  end
end