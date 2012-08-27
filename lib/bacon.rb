class Bacon

  def initialize(window, field_width, field_height)
    @image = Gosu::Image.new(window, "media/bacon.png", true)
    @field_width = field_width
    @field_height = field_height
    @x_offset = @image.width / 2.0
    @y_shift = -1.0 * @image.height / 2.0
    @x = 80
    @y = 80
  end

  def move_bacon
  end

  def draw
      @image.draw(@x, @y, 1)
      @image.draw(@x, @y, 1, 12, factor_y = 1)
      move_bacon
  end

end
