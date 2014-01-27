require 'bounds'

class Actor

  attr_accessor :window,
    :image,
    :x, :y, :z,
    :width, :height,   
    :viewport_width, :viewport_height,
    :visible,
    :x_shift, :y_shift
    :bounds

  def initialize(cfg={})

    raise "Actor requires a Gosu Window" if cfg[:window].nil?

    default_config = {
      x: 0, y: 0, z: 1,
      width: 0, height: 0,
      viewport_width: 0,
      viewport_height: 0,
      visible: false,
    }
    cfg = default_config.merge(cfg)

    @window = cfg[:window]
    @x = cfg[:x]
    @y = cfg[:y]
    @z = cfg[:z]
    @viewport_width = cfg[:viewport_width]
    @viewport_height = cfg[:viewport_height]
    @visible = cfg[:visible]

    @width   = cfg[:width].nil?   ? 0 : cfg[:width]
    @height  = cfg[:height].nil?  ? 0 : cfg[:height]
    @x_shift = cfg[:x_shift].nil? ? 1 : cfg[:x_shift]
    @y_shift = cfg[:y_shift].nil? ? 1 : cfg[:y_shift]

    if cfg[:image].is_a?(String)
      @image = Gosu::Image.new(@window, cfg[:image], false)
    else
      @image = cfg[:image]
    end
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
    Bounds.new(@x, @y, right, bottom)
  end

  def bounds=(val)
    @x = bounds.x
    @y = bounds.y
    @width = bounds.width
    @height = bounds.height
  end

  def visible?
    @visible
  end

  def show(visible=true)
    @visible = visible
  end

  def draw
    gone?
    @image.draw(@x, @y, @z) unless @image.nil? || !@visible
  end

  def shift(x_delta=1, y_delta=1)
    @x = @x + (x_delta * @x_shift)
    @y = @y + (y_delta * @y_shift)
    gone?
  end

  def move(x, y)
    @x = x
    @y = y
    gone?
  end

  def gone?
    gone = @x > @viewport_width || @y > @viewport_height || (@x + height) < 0 || (@y + width) < 0

    if gone
      @visible = false
    end

    return gone
  end

  def corners
    [
      {:x => @x,    :y => @y}, 
      {:x => right, :y => @y}, 
      {:x => @x,    :y => bottom}, 
      {:x => right, :y => bottom}
    ]
  end

end
