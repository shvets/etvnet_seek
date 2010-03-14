class UserSelection
  attr_reader :index

  def parse text
    @blank = text.strip.size == 0

    result = text.split

    @index = result[0].to_i-1
    @quit = (result & ['q', 'Q']).empty? ? false : true
    @catalog = (result & ['c', 'C']).empty? ? false : true
  end

  def quit?
    @quit
  end

  def blank?
    @blank
  end

  def catalog?
    @catalog
  end

end
