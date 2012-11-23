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

      total_bits = @bits.count * @bits[0].count
      bits_gone = 0

      y = @y
      @bits.each do |row|
        x = @x
        row.each do |bit|
          check_for_hit(bit, x, y)
          if bit[:present] 
            bit[:img].draw(x, y, 1)
          else
            bits_gone += 1
          end
          x += @bit_size
        end
        y += @bit_size
      end

      if bits_gone == total_bits
        sleep 0.4
        @win.play
        @complete = true
      end
    end
  end

private

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

  def check_for_hit(bit, x, y)
    if @ammo.visible && bit[:present]
      a = {}
      a[:x], a[:y], a[:right], a[:bottom] = @ammo.bounds
      b = {}
      b[:x], b[:y], b[:right], b[:bottom] = x, y, x + @bit_size, y + @bit_size

      # Check each corner of the ammo to see if it is inside the bit
      ammo_corners = [
        {:x => a[:x],     :y => a[:y]},
        {:x => a[:right], :y => a[:y]},
        {:x => a[:x],     :y => a[:bottom]},
        {:x => a[:right], :y => a[:bottom]}
      ].each do |c|
        if ((c[:x] >= b[:x]) && (c[:x] <= b[:right]) &&
            (c[:y] >= b[:y]) && (c[:y] <= b[:bottom]))
          bit[:present] = false
          @ammo.visible = false
          @boom.stop
          @boom.play
          return true
        end
      end
    end
    return false
  end

  private

  def load_bacon(width_in_bits)
    img = Gosu::Image.new(@window, "media/bacon.png")
    @bit_size = img.width
    @num_rows = img.height / @bit_size
    tiles = Gosu::Image.load_tiles(@window, "media/bacon.png", @bit_size, @bit_size, true)

    @bits = Array.new(@num_rows)
    p @bits
    @bits.each_index do |row|
      @bits[row] = []
      width_in_bits.times do
        @bits[row] << {:img => tiles[row], :present => true}
      end
    end

    @bits.each do |row|
      p row
    end

    @x = @x_min = 60
    @x_max = 400
    @y = @y_min = 80
    @y_max = 200
    @direction = :right
    @rise = false
  end

end
