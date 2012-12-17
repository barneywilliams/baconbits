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

  def initialize(cfg, image=nil, x=0, y=0, viewport_width=0, viewport_height=0, visible=false, z=5)

    default_config = {
      x: 0, y: 0, z: 1,
      width: 0, height: 0,
      viewport_width: 0,
      viewport_height: 0,
      visible: false,
    }

    if cfg.is_a?(Hash)
      cfg = default_config.merge(cfg)
      @window = cfg[:window]
      @image = cfg[:image]
      @x = cfg[:x]
      @y = cfg[:y]
      @viewport_width = cfg[:viewport_width]
      @viewport_height = cfg[:viewport_height]
      @visible = cfg[:visible]
      @z = cfg[:z]
    else
      @window = cfg
      @image = image
      @x = x
      @y = y
      @viewport_width = viewport_width
      @viewport_height = viewport_height
      @visible = visible
      @z = z
    end

    @width = @height = 0
    @x_shift = @y_shift = 1
  end

  # def initialize(cfg={})
  #   @window       = cfg[:window]
  #   raise "Actor requires a Gosu Window" if @window.nil?

  #   @image        = cfg[:image]        if !cfg[:image].nil?
  #   @x            = cfg[:x]            ? cfg[:x]            : 0
  #   @y            = cfg[:y]            ? cfg[:y]            : 0
  #   @viewport_width  = cfg[:viewport_width]  ? cfg[:viewport_width]  : 400
  #   @viewport_height = cfg[:viewport_height] ? cfg[:viewport_height] : 400
  #   @visible      = cfg[:visible]      ? cfg[:visible]      : false
  #   @z      = cfg[:z]      ? cfg[:z]      : 1
  #   @width        = cfg[:width]        ? cfg[:width]        : 0
  #   @height       = cfg[:height]       ? cfg[:height]       : 0
  #   @x_shift      = cfg[:x_shift]      ? cfg[:x_shift]      : 1
  #   @y_shift      = cfg[:y_shift]      ? cfg[:y_shift]      : 1
  # end

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
