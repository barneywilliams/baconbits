class Ammo
  def intitialize(window, field_width, field_height)
    @image = Gosu::Image.new(window, "media/ammo.png", false)
    @field_width = field_width
    @field_height = field_height
    @visible = false
    @x_offset = @image.width / 2.0
    @y_shift = -1.0 * @image.height / 2.0
  end

  def fire_from(x, y)
    @x = x
    @y = y
    @visible = true
  end

  def move_ammo
    @y += @y_shift
    if @y < 0
      @visible = false
    end
  end

  def draw
    if @visible
      @image.draw(@x, @y, 1)
      move_ammo
    end
  end
end