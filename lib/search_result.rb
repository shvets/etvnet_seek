class SearchResult
  attr_reader :link, :name

  def initialize(link, name)
    @link = link
    @name = name
  end

  def resolved?
    not @link.nil?
  end
end