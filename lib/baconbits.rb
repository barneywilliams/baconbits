require 'rubygems' # only necessary in Ruby 1.8
require 'gosu'

$LOAD_PATH << File.dirname(__FILE__)
require 'player'

class BaconBitsWindow < Gosu::Window

  def initialize
    super(640, 480, false)
    self.caption = 'BaconBits'
    @background_image = Gosu::Image.new(self, "media/background.png", true)

    @player = Player.new(self)
    @player.warp(320, 405)
  end

  def update
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      @player.shift(-1)
    end
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      @player.shift(1)
    end
    # if button_down? Gosu::KbUp or button_down? Gosu::GpButton0 then
    #   @player.accelerate
    # end
    # @player.move
  end
  
  def draw
    @player.draw
    @background_image.draw(0, 0, 0)
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end

end

window = BaconBitsWindow.new
window.show