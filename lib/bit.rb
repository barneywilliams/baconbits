require 'actor'

class Bit < Actor

  attr_accessor :falling,
    :horizontal_shift_width,
    :vertical_shift_height

  def initialize(window, image=nil, x=0, y=0, visible=false)
    super(window, image, x, y, visible)
    @falling = false
  end

end
