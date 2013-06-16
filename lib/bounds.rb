
class Bounds
  
  attr_accessor :x, :y, :right, :bottom

  def initialize(x=0, y=0, right=0, bottom=0)
    @x = x
    @y = y
    @right = right
    @bottom = bottom
  end

  def width
    return @right - @x
  end

  def width=(val)
    @right = @x + val
    raise if @right < 0
  end

  def height
    @bottom - @y
  end

  def height=(val)
    @bottom = @y - val
    raise if @bottom < 0
  end

end