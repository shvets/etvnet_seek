class UserSelection
  attr_reader :index1, :index2

  def initialize text
    parse text
  end

  def one_level?
    index2.nil?
  end

  def quit?
    @quit
  end

  def archive?
    @archive
  end

  def item items
    one_level? ? items[index1] : items[index1].container[index2]
  end

  private

  def parse text
    @quit = (['q', 'Q'].include? text) ? true : false

    dot_index = text.index('.')

    if not dot_index.nil?
      part1 = text[0..dot_index-1]
      part2 = text[dot_index+1..-1]

      @index1 = (part1.to_i)-1

      @archive = (['a', 'A'].include? part2) ? true : false

      if not @archive
        @index2 = (part2.to_i)-1
      else
        @index2 = nil
      end
    else
      @index1 = text.to_i-1
      @index2 = nil
    end
  end
end
