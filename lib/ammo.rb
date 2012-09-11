class Ammo

  attr_accessor :visible

  def initialize(window, field_width, field_height)
    @image = Gosu::Image.new(window, "media/ammo.png", false)
    @field_width = field_width
    @field_height = field_height
    @visible = false
    @x_offset = @image.width / 2.0
    @y_shift = -1.0 * @image.height / 2.0
    @rot = 0
  end

  def fire_from(x, y)
    if !@visible
      @x = x - @x_offset
      @y = y
      @visible = true
    end
  end

  def move_ammo
    @y += @y_shift
    if @y < 0
      @visible = false
    end
  end

  def draw
    if @visible
      #@image.draw(@x, @y, 1)
      @rot += 60
      @image.draw_rot(@x, @y, 1, @rot)
      move_ammo
    end
  end

  def bounds
    return @x, @y, @x + @image.width, @y + @image.height
  end
end