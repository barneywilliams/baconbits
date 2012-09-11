require 'rubygems' # only necessary in Ruby 1.8
require 'gosu'

$LOAD_PATH << File.dirname(__FILE__)
require 'player'
require 'ammo'
require 'bacon'
require 'status'

class BaconBitsWindow < Gosu::Window

  def initialize
    super(640, 480, false)
    self.caption = 'BaconBits'
    @background_image = Gosu::Image.new(self, "media/background.png", true)

    @level_complete = Gosu::Image.from_text(self, "Yay! A Winner is You!!", "Consolas", 24)

    @complete_x = (640 / 2) - (@level_complete.width / 2)
    @complete_y = (480 / 2) - (@level_complete.height / 2)

    @status = Status.new(self, 640, 480)
    @ammo = Ammo.new(self, 640, 480)
    @bacon = Bacon.new(self, @ammo, 640, 480)
    @player = Player.new(self, @ammo)
    @player.warp(320, 405)
  end

  def update
    
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      @player.shift(-1)
    end
    
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      @player.shift(1)
    end

    if button_down? Gosu::KbUp or button_down? Gosu::GpButton0 then
      @player.fire
    end

    if button_down? Gosu::KbSpace then
      @player.fire
    end

  end
  
  def draw
    if @bacon.complete
      @level_complete.draw(@complete_x, @complete_y, 0.8)
    else
      @bacon.draw
    end

    @ammo.draw
    @player.draw
    @status.draw
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
