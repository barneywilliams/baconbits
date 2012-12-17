require 'actor'
require 'ammo'

class Player < Actor
  def initialize(window, ammo, x, y, field_width, field_height)
    image = Gosu::Image.new(window, "media/actor.png", false)
    super(window, image, x, y, field_width, field_height, true, 0)
    @z = 0
    @visible = true
    @shift_width = 4.0
    @score = 0
    @x_padding = 40.0
    @ammo = ammo
  end 

  def shift(horiz_offset, vertical_offset)
    @x += @shift_width * horiz_offset
    if (@x < @x_padding)
      @x = @x_padding
    elsif (@x > (640 - @image.width - @x_padding))
      @x = 640 - @image.width - @x_padding
    end
  end

  def fire
    @ammo.fire_from(top, @y)
  end

end
