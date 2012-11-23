require 'ammo.rb'

class Player

  attr_reader :width, :height, :x, :y

  def initialize(window, ammo)
    @image = Gosu::Image.new(window, "media/actor.png", false)
    @width = @image.width
    @height = @image.height
    @x = @y = 0.0
    @score = 0
    @shift_width = 4.0
    @x_padding = 40.0
    @ammo = ammo
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

  def fire
    @ammo.fire_from(top, @y)
  end

  def draw
    @image.draw(@x, @y, 1)
  end

  private

  def top
    @x + @image.width / 2.0
  end

end
