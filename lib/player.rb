require 'ammo.rb'

class Player
  def initialize(window)
    @image = Gosu::Image.new(window, "media/actor.png", false)
    @x = @y = 0.0
    @score = 0
    @shift_width = 4.0
    @x_padding = 40.0
  end

  def warp(x, y)
    @x, @y = x, y
  end

  def shift(horiz_offset)
    @x += @shift_width * horiz_offset
    if (@x < @x_padding)
      @x = @x_padding
    elsif (@x > (640 - @image.width - @x_padding))
      @x = 640 - @image.width - @x_padding
    end
  end

  def draw
    @image.draw(@x, @y, 1)
  end
end
