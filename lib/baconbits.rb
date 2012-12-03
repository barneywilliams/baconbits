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
    @bacon_width = 20

    @actors = {}

    @actors[:background] = Actor.new(self,
      Gosu::Image.new(self, "media/background.png", true),
      0, 0, @width, @height, true, 0)

    @actors[:title] = Actor.new(self,
      Gosu::Image.new(self, "media/title.png", true),
      0, 0, @width, @height, true)
    @actors[:title].move(
      0.5*(@width - @actors[:title].width),
      8)

    @actors[:level_complete] = Actor.new(self,
      Gosu::Image.from_text(self, "Yay! A Winner is You!!", "Consolas", 24),
      0, 0, @width, @height)
    @actors[:level_complete].move(
      0.5*(@width - @actors[:level_complete].width),
      0.5*(@height - @actors[:level_complete].height))

    @actors[:status] = Status.new(self, @width, @height)
    @actors[:ammo] = Ammo.new(self, @width, @height)
    @actors[:bacon] = Bacon.new(self, @actors[:ammo], @actors[:status], 
      @bacon_width, @width, @height)
    @actors[:player] = Player.new(self, @actors[:ammo],
      0, 0, @width, @height)
    @actors[:player].move(
      0.5*(@width - @actors[:player].width),
      0.9*@height - 0.5*@actors[:player].height)
  end

  def update
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      @actors[:player].shift(-1, 0)
    end
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      @actors[:player].shift(1, 0)
    end
    if button_down? Gosu::KbUp or button_down? Gosu::GpButton0 or button_down? Gosu::KbSpace then
      @actors[:player].fire
    end
  end
  
  def draw
    if @actors[:bacon].complete && !@level_complete.visible
      @actors[:level_complete].show(true)
    end
    @actors.each_value{|actor| actor.draw}
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    elsif id == Gosu::KbR
      @actors[:bacon].cook(5)
      @actors[:ammo].reset
      @actors[:status].reset
    end
  end

end

window = BaconBitsWindow.new
window.show
