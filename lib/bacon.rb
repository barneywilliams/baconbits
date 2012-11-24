require 'bit'

class Bacon

  attr_reader :complete

  def initialize(window, ammo, field_width, field_height)
    @window = window
    @ammo = ammo
    @field_width = field_width
    @field_height = field_height

    load_bacon 5  

    @boom = Gosu::Song.new("media/boom.wav")
    @win = Gosu::Song.new("media/applause.wav")

    @complete = false
  end
                                                                                                                               
  def draw
    if !@complete
      move_bacon
      x = @x
      y = @y

      bits_left = @bits.count * @bits[0].count

      y = @y
      @bits.each do |row|
        x = @x
        row.each do |bit|
          bit.x = x
          bit.y = y
          check_for_hit(bit)
          if bit.visible?
            bit.draw
          else
            bits_left -= 1
          end
          x += @bit_size
        end
        y += @bit_size
      end

      if bits_left <= 0
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
  end

  def move_bacon
    if @direction == :left
      @x -= @bit_size / 16
    else
      @x += @bit_size / 16
    end

    y_sign = @rise ? -1.0 : 1.0
    y_shift = (@bit_size / 2) * y_sign
    if @x > @x_max
      @direction = :left
      @y += y_shift
    elsif @x < @x_min
      @direction = :right
      @y += y_shift
    end

    if @y > @y_max
      @rise = true
    elsif @y < @y_min
      @rise = false
    end
  end

  def check_for_hit(bit)
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
          return true
        end
      end
    end
    return false
  end

end
