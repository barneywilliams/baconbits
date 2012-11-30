class Actor

  attr_accessor :window, :image,
    :x, :y,
    :field_width, :field_height,
    :visible,
    :x_shift, :y_shift

  def initialize(window, image, x, y, field_width, field_height, visible=false)
    @window = window
    @image = image
    @x = x
    @y = y
    @field_width = field_width
    @field_height = field_height
    @visible = visible
    @width = @height = 0
    @x_shift = @y_shift = 1
  end

  def width
    return @image ? @image.width : @width
  end

  def height
    return @image ? @image.height : @height
  end

  def top
    @x + width / 2.0
  end

  def right
    @x + width
  end

  def bottom
    @y + height
  end

  def bounds
    return @x, @y, right, bottom
  end

  def visible?
    @visible
  end

  def show(visible=true)
    @visible = visible
  end

  def draw
    @image.draw(@x, @y, 1) unless @image.nil? || !@visible
  end

  def shift(x_delta, y_delta)
    @x = @x + (x_delta * @x_shift)
    @y = @y + (y_delta * @y_shift)
  end

  def move(x, y)
    @x = x
    @y = y
  end

end
