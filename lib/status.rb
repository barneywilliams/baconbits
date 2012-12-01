require 'actor'

class Status < Actor

  def initialize(window, field_width, field_height)
    super(window, nil, 0, 0, field_width, field_height)
    @start_score = 420
    @score_y = 10
    @score_x_offset = 40

    @start_lives = 3
    @life = Gosu::Image.new(window, "media/life.png", false)
    @lives_x = 20
    @lives_y = 10
    @next_life_offset = 40

    reset
  end

  def reset
    self.score = @start_score
    @lives = Array.new(@start_lives, @life)
  end

  def die
    @lives.pop
  end

  def score=(value)
    @current_score = value
    @score_img = Gosu::Image.from_text(@window, @current_score.to_s, "Andale Mono", 30)
    @score_x = @field_width - @score_img.width - @score_x_offset
  end

  def draw
    life_x = @lives_x
    @lives.each do |life|
      life.draw(life_x, @lives_y, 2)
      life_x += @next_life_offset
    end

    @score_img.draw(@score_x, @score_y, 2)
  end

  private
end
