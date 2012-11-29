require 'actor'

class Status < Actor
  def initialize(window, field_width, field_height)
    @score = Gosu::Image.from_text(window, "420", "Andale Mono", 30)
    @field_width = field_width
    @field_height = field_height

    @start_lives = 3
    @lives = Array.new(@start_lives, Gosu::Image.new(window, "media/life.png", false))
  end

  def draw
    life_x = 20
    life_y = 10
    @lives.each do |life|
      life.draw(life_x, life_y, 0)
      life_x += 40
    end

    score_x = @field_width - @score.width - 40
    @score.draw(score_x, 0, 1)
  end
end
