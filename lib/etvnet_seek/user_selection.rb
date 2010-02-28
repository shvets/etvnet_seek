class UserSelection
  attr_reader :index

  def parse text
    @blank = text.strip.size == 0

    result = text.split

    @index = result[0].to_i-1
    @quit = (result & ['q', 'Q']).empty? ? false : true
    @archive = (result & ['a', 'A']).empty? ? false : true

#    @quit = (['q', 'Q'].include? text) ? true : false
#    @blank = text.strip.size == 0
#    dot_index = text.index('.')
#
#    if not dot_index.nil?
#      part1 = text[0..dot_index-1]
#      part2 = text[dot_index+1..-1]
#
#      @index = (part1.to_i)-1
#
#      @archive = (['a', 'A'].include? part2) ? true : false
#    else
#      @index = text.to_i-1
#    end
  end

  def quit?
    @quit
  end

  def blank?
    @blank
  end

  def archive?
    @archive
  end

  def item items
    items[index]
  end

end
