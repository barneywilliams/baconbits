class Status
  def initialize(window, field_width, field_height)
    @score = Gosu::Image.from_text(window, "420", "Andale Mono", 30)
    @lives = Gosu::Image.from_text(window, "Lives: 3", "Andale Mono", 30)
    @field_width = field_width
    @field_height = field_height
  end

  def draw
    @score.draw(3, 0, 1)
    lives_x = @field_width - @lives.width - 10
    @lives.draw(lives_x, 0, 1)
  end
end
