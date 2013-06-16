require 'actor'

class Ammo < Actor

  def initialize(cfg)
    cfg[:image] = Gosu::Image.new(cfg[:window], "media/ammo.png", false)
    super(cfg)
    @x_offset = @width / 2.0
    @rot = 0
  end

  def reset
    @visible = false
  end

  def fire_from(x, y)
    if !@visible
      @x = x - @x_offset
      @y = y
      @visible = true
    end
  end

  def draw
    if @visible
      if @y < 0
        @visible = false
      end
      @rot += 60
      @image.draw_rot(@x, @y, 1, @rot)
      shift(0, height * -0.5)
    end
  end

end