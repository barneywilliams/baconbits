require 'actor'

class Bit < Actor

  attr_accessor :falling

  def initialize(window, image=nil, x=0, y=0, field_width=0, field_height=0, visible=false)
    super(window, image, x, y, field_width, field_height, visible, 1)
    @falling = false
  end

  def reset(x, y)
  	@x = x
  	@y = y
  	@visible = true
  	@falling = false
  end

end
