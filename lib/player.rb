require 'actor'
require 'ammo'

class Player < Actor
  def initialize(cfg)
    super(cfg)
    @shift_width = 4.0
    @x_padding = 40.0
    @ammo = cfg[:ammo]
  end 

  def shift(horiz_offset, vertical_offset)
    @x += @shift_width * horiz_offset
    if (@x < @x_padding)
      @x = @x_padding
    elsif (@x > (@viewport_width - width - @x_padding))
      @x = @viewport_width - width - @x_padding
    end
  end

  def fire
    @ammo.fire_from(top, @y)
  end

end
