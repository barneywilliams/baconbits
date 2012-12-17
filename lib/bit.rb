require 'actor'

class Bit < Actor

  attr_accessor :falling

  def initialize(cfg)
    super(cfg)
    @falling = false
  end

  def reset(x, y)
  	@x = x
  	@y = y
  	@visible = true
  	@falling = false
  end

end
