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
    self.caption = 'BaconBits'
    @background_image = Gosu::Image.new(self, "media/background.png", true)
    @title = Gosu::Image.new(self, "media/title.png", true)
    @title_x = (@width * 0.5) - (@title.width * 0.5)
    @title_y = 8

    @level_complete = Gosu::Image.from_text(self, "Yay! A Winner is You!!", "Consolas", 24)

    @complete_x = (@width * 0.5) - (@level_complete.width * 0.5)
    @complete_y = (@height * 0.5) - (@level_complete.height * 0.5)

    @status = Status.new(self, @width, @height)
    @ammo = Ammo.new(self, @width, @height)
    @bacon = Bacon.new(self, @ammo, @width, @height)
    @player = Player.new(self, @ammo)
    player_x = (@width * 0.5) - (@player.width * 0.5)
    player_y = (@height * 0.9) - (@player.height * 0.5)
    @player.warp(player_x, player_y)
  end

  def update
    
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      @player.shift(-1)
    end
    
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      @player.shift(1)
    end

    if button_down? Gosu::KbUp or button_down? Gosu::GpButton0 or button_down? Gosu::KbSpace then
      @player.fire
    end

  end
  
  def draw

    @background_image.draw(0, 0, 0)
    
    @status.draw
    @title.draw(@title_x, @title_y, 0)

    @player.draw
    @ammo.draw

    if @bacon.complete
      @level_complete.draw(@complete_x, @complete_y, 0.8)
    else
      @bacon.draw
    end

  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end

end

window = BaconBitsWindow.new
window.show
