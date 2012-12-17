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

    actor_defaults = {
      :window => self,
      :viewport_width => @width,
      :viewport_height => @height,
      :visible => false
    }

    @actors[:background] = Actor.new(actor_defaults.merge(
      image: Gosu::Image.new(self, "media/background.png", true),
      z: 0, visible: true))

    @actors[:title] = Actor.new(actor_defaults.merge(
      image: Gosu::Image.new(self, "media/title.png", true),
      z: 1, visible: true))
    @actors[:title].move(0.5*(@width - @actors[:title].width), 8)

    @actors[:status] = Status.new(actor_defaults.merge(z: 3))

    @actors[:ammo] = Ammo.new(actor_defaults.merge(z: 1))

    @actors[:player] = Player.new(self, @actors[:ammo],
      0, 0, @width, @height)
    @actors[:player].move(
      0.5*(@width - @actors[:player].width),
      0.9*@height - 0.5*@actors[:player].height)
    
    @actors[:bacon] = Bacon.new(actor_defaults.merge(
      ammo: @actors[:ammo],
      status: @actors[:status],
      width_in_bits: @bacon_width,
      visible: true,
      z: 8))

    @actors[:level_complete] = Actor.new(actor_defaults.merge(
      image: Gosu::Image.from_text(self, "Yay! A Winner is You!!", "System", 24)))
    @actors[:level_complete].move(
      0.5*(@width - @actors[:level_complete].width),
      0.5*(@height - @actors[:level_complete].height))
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
    @actors.each{|name, actor| actor.draw}
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
