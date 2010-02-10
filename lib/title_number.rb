class TitleNumber
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

  private

  def parse text
    @quit = (['q', 'Q'].include? text) ? true : false

    dot_index = text.index('.')

    if not dot_index.nil?
      @index1 = (text[0..dot_index-1].to_i)-1
      @index2 = (text[dot_index+1..-1].to_i)-1
    else
      @index1 = text.to_i-1
      @index2 = nil
    end
  end
end
