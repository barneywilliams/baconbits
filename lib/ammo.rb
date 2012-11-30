require 'actor'

class Ammo < Actor

  def initialize(window, field_width, field_height)
    super(window, Gosu::Image.new(window, "media/ammo.png", false), 0, 0, field_width, field_height)
    @x_offset = @width / 2.0
    @rot = 0
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