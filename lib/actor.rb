class Actor

  attr_accessor :window, :image, :x, :y, :visible

  def initialize(window, image=nil, x=0, y=0, visible=false)
    @window = window
    @image = image
    @x = x
    @y = y
    @visible = visible
  end

  def width
    @image.nil? ? nil : @image.width
  end

  def height
    @image.nil? ? nil : @image.height
  end

  def visible?
    @visible
  end

  def draw
    @image.draw(x, y, 1) unless @image.nil?
  end

end