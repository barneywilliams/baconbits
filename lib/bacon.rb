require 'actor'
require 'bit'

class Bacon < Actor

  attr_reader :complete

  def initialize(window, ammo, field_width, field_height)
    super(window, nil, 0, 0, field_width, field_height, true)

    @ammo = ammo
    @complete = false
    load_bacon(5)
    @boom = Gosu::Song.new("media/boom.wav")
    @win = Gosu::Song.new("media/applause.wav")
  end
                                                                                                                               
  def draw
    if !@complete
      move_bacon

      @bits.each do |row|
        row.each do |bit|
          check_for_hit(bit)
          bit.draw
        end
      end

      if @bits_left <= 0
        sleep 0.4
        @win.play
        @complete = true
      end
    end
  end

private

  def load_bacon(width_in_bits)
    img = Gosu::Image.new(@window, "media/bacon.png")
    @bit_size = img.width
    @num_rows = img.height / @bit_size
    tiles = Gosu::Image.load_tiles(@window, "media/bacon.png", @bit_size, @bit_size, true)
    @x = @x_min = 60
    @x_max = 400
    @y = @y_min = 80
    @y_max = 200
    @direction = :right
    @rise = false

    # Assemble the bacon from bits
    x = @x
    y = @y
    @bits = Array.new(@num_rows)
    @bits.each_index do |row|
      x = @x
      @bits[row] = []
      width_in_bits.times do
        @bits[row] << Bit.new(@window, tiles[row], x, y, true)
        x += @bit_size
      end
      y += @bit_size
    end

    @bits_left = @bits.count * @bits[0].count
    p "Bits: #{@bits_left}"
  end

  def move_bacon
    # calculate shift
    x_sign = @direction == :left ? -1 : 1
    x_shift = (@bit_size / 16) * x_sign
    @x += x_shift
    y_sign = @rise ? -1 : 1
    y_shift = (@bit_size / 2) * y_sign
    @y += y_shift

    # update direction if we've hit a boundary
    if @x > @x_max
      @direction = :left
    elsif @x < @x_min
      @direction = :right
    end
    if @y > @y_max
      @rise = true
    elsif @y < @y_min
      @rise = false
    end

    # shift each bit accordingly
    @bits.each do |row|
      row.each do |bit|
        bit.shift(x_shift, y_shift)
      end
    end
  end

  def check_for_hit(bit)
    hit = false

    if @ammo.visible && bit.visible?
      a = {}
      a[:x], a[:y], a[:right], a[:bottom] = @ammo.bounds
      b = {:x=>bit.x, :y=>bit.y, :right=>bit.x+@bit_size, :bottom=>bit.y+@bit_size}

      # Check each corner of the ammo to see if it is inside the bit
      ammo_corners = [
        {:x => a[:x],     :y => a[:y]},
        {:x => a[:right], :y => a[:y]},
        {:x => a[:x],     :y => a[:bottom]},
        {:x => a[:right], :y => a[:bottom]}
      ].each do |c|
        if ((c[:x] >= b[:x]) && (c[:x] <= b[:right]) &&
            (c[:y] >= b[:y]) && (c[:y] <= b[:bottom]))
          bit.visible = false
          bit.falling = true
          @ammo.visible = false
          @boom.stop
          @boom.play
          @bits_left -= 1
          hit = true
        end
      end
    end

    return hit
  end

end
