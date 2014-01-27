require 'actor'
require 'bit'

class Bacon < Actor

  attr_reader :complete

  def initialize(cfg)
    super(cfg)
    @bit_cfg = cfg.dup
    @ammo =    cfg[:ammo]
    @status =  cfg[:status]
    @width_in_bits = cfg[:width_in_bits]

    @score_per_bit = 50
    @complete = false
    @boom = Gosu::Sample.new("media/boom.wav")
    @you_win = Gosu::Sample.new("media/applause.wav")
    @you_win_inst = nil

    load_bacon
  end

  def cook(width_in_bits)
    @width_in_bits = width_in_bits
    prep_bacon
  end
                                                                                                                               
  def draw
    if !@complete
      move_bacon
      
      if gone?
        win
      else
        @bits.each do |row|
          row.each do |bit|
            check_for_hit(bit) if @ammo.visible
            bit.draw
          end
        end

        win if @bits_left <= 0
      end

    end
  end

private

  def load_bacon
    img = Gosu::Image.new(@window, "media/bacon.png")
    @bit_size = img.width
    @num_rows = img.height / @bit_size
    @tiles = Gosu::Image.load_tiles(@window, "media/bacon.png", @bit_size, @bit_size, true)
    prep_bacon
  end

  def prep_bacon
    if @you_win_inst
      @you_win_inst.stop
      @you_win_inst = nil
    end

    @x = @x_min = 60
    @x_max = 400
    @y = @y_min = 80
    @y_max = 200
    @x_sign = 1
    @y_sign = 1

    # Assemble the bacon from bits
    bit_x = @x
    bit_y = @y

    if @bits.nil?
      @bits = Array.new(@num_rows)
      @bits_left = 0
      @bits.each_index do |row|
        bit_x = @x
        @bits[row] = []
        @width_in_bits.times do
          @bits[row] << Bit.new(@bit_cfg.merge(
            x: bit_x, y: bit_y, image: @tiles[row], visible: true))
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
    @x_shift = @bit_size * 0.02
    @y_shift = @bit_size * 0.03
    shift

    # update direction if we've hit a boundary
    # if right > @x_max
    #   @x_sign = -1
    # elsif @x < @x_min
    #   @x_sign = 1
    # end
    # if bottom > @y_max
    #   @y_sign = -1
    # elsif @y < @y_min
    #   @y_sign = 1
    # end

    # shift each bit accordingly
    @bits.each do |row|
      row.each do |bit|
        bit.shift(@x_shift, @y_shift)
      end
    end
  end

  def check_for_hit(bit)
    hit = false

    if @ammo.visible && bit.visible && !bit.falling
      b = Bounds.new(bit.x, bit.y, bit.x+@bit_size, bit.y+@bit_size)

      # Check each corner of the ammo to see if it is inside the bit
      @ammo.corners.each do |c|
        if ((c[:x] >= b.x) && (c[:x] <= b.right) &&
            (c[:y] >= b.y) && (c[:y] <= b.bottom))
          bit.visible = false
          @ammo.visible = false
          puts "x"
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

  def win
    sleep 0.4
    @you_win_inst = @you_win.play
    @complete = true
  end

end
