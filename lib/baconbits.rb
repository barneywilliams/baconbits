require 'rubygems' # only necessary in Ruby 1.8
require 'gosu'

$LOAD_PATH << File.dirname(__FILE__)
require 'player'
require 'ammo'
require 'bacon'
require 'status'

class BaconBitsWindow < Gosu::Window

  def initialize
    @width = 727
    @height = 512
    super(@width, @height, false)
    self.caption = 'Bacon Bits'

    @actors = []

    @background = Actor.new(self,
      Gosu::Image.new(self, "media/background.png", true),
      0, 0,
      @width, @height,
      true)
    @actors << @background

    @title = Actor.new(self,
      Gosu::Image.new(self, "media/title.png", true),
      0, 0,
      @width, @height,
      true)
    @title.move((@width * 0.5) - (@title.width * 0.5), 8)
    @actors << @title

    @level_complete = Actor.new(self,
      Gosu::Image.from_text(self, "Yay! A Winner is You!!", "Consolas", 24),
      0, 0,
      @width, @height,
      false)
    @level_complete.move(
      (@width * 0.5)  - (@level_complete.width * 0.5),
      (@height * 0.5) - (@level_complete.height * 0.5))
    @actors << @level_complete

    @status = Status.new(self, @width, @height)
    @actors << @status
    @ammo = Ammo.new(self, @width, @height)
    @actors << @ammo
    @bacon = Bacon.new(self, @ammo, @width, @height)
    @actors << @bacon

    @player = Player.new(self, @ammo, @width, @height)
    @player.move((@width * 0.5) - (@player.width * 0.5), (@height * 0.9) - (@player.height * 0.5))
    @actors << @player
  end

  def update
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      @player.shift(-1, 0)
    elsif button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      @player.shift(1, 0)
    elsif button_down? Gosu::KbUp or button_down? Gosu::GpButton0 or button_down? Gosu::KbSpace then
      @player.fire
    elsif button_down? Gosu::KbEscape
      close
    end
  end
  
  def draw
    if @bacon.complete && !@level_complete.visible
      @level_complete.show(true)
    end
    @actors.each{|actor| actor.draw}
  end

end

window = BaconBitsWindow.new
window.show
