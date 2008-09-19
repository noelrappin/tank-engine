class ListModel
  attr_accessor :caption, :url, :obj
  
  def initialize(obj, caption, url)
    @obj = obj
    @caption = caption
    @url = url
  end
end