require 'actor'
require 'bit'

class Bacon < Actor

  attr_reader :complete

  def initialize(window, ammo, status, width_in_bits, field_width, field_height)
    super(window, nil, 0, 0, field_width, field_height, true)
    @ammo = ammo
    @status = status

    load_bacon(width_in_bits)

    @score_per_bit = 50
    @complete = false
    @boom = Gosu::Sample.new("media/boom.wav")
    @you_win = Gosu::Sample.new("media/applause.wav")
    @you_win_inst = nil
  end

  def cook(width_in_bits)
    prep_bacon(width_in_bits)
  end
                                                                                                                               
  def draw
    if !@complete
      move_bacon

      @bits.each do |row|
        row.each do |bit|
          check_for_hit(bit) if @ammo.visible
          bit.draw
        end
      end

      if @bits_left <= 0
        sleep 0.4
        @you_win_inst = @you_win.play
        @complete = true
      end
    end
  end

private

  def load_bacon(width_in_bits)
    img = Gosu::Image.new(@window, "media/bacon.png")
    @bit_size = img.width
    @num_rows = img.height / @bit_size
    @tiles = Gosu::Image.load_tiles(@window, "media/bacon.png", @bit_size, @bit_size, true)
    prep_bacon(width_in_bits)
  end

  def prep_bacon(width_in_bits)
    if @you_win_inst
      @you_win_inst.stop
      @you_win_inst = nil
    end

    @x = @x_min = 60
    @x_max = 400
    @y = @y_min = 80
    @y_max = 200
    @direction = :right
    @rise = false

    # Assemble the bacon from bits
    bit_x = @x
    bit_y = @y

    if @bits.nil?
      @bits = Array.new(@num_rows)
      @bits_left = 0
      @bits.each_index do |row|
        bit_x = @x
        @bits[row] = []
        width_in_bits.times do
          @bits[row] << Bit.new(@window, @tiles[row], bit_x, bit_y, @field_width, @field_height, true)
          bit_x += @bit_size
          @bits_left += 1
        end
        bit_y += @bit_size
      end
    else
      @bits.each do |row|
        bit_x = @x
        row.each do |bit|
          bit.reset(bit_x, bit_y)
          bit_x += @bit_size
          @bits_left += 1
        end
        bit_y += @bit_size
      end
    end
  end

  def move_bacon
    # calculate shift
    x_sign = @direction == :left ? -1 : 1
    @x_shift = (@bit_size / 16) * x_sign
    y_sign = @rise ? -1 : 1
    @y_shift = (@bit_size / 2) * y_sign

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
        bit.shift(1, 1)
      end
    end
  end

  def check_for_hit(bit)
    hit = false

    if @ammo.visible && bit.visible && !bit.falling
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
          @ammo.visible = false
          @bits_left -= 1
          hit = true
          break
        end
      end
    end

    if hit && !bit.falling
      @status.score += @score_per_bit
      @boom.play
      bit.falling = true
    end

    return hit
  end

end
