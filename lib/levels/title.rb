# frozen_string_literal: true

class TitleScreen
  def initialize
    # Parallax background.
    @bg = Gosu::Image.new('sprites/background/colored_grass.png', tileable: true)
    @bg_scale = 0.7032 # 1024px to 720px.
    @bg_positions = (-1..64).map { |x| x * 720 } # Enough background for ~6 minutes before we scroll off-screen.
    @bg_speed = 2.0
  end

  def update
    @bg_positions.map! { |x| x - @bg_speed }
  end

  def draw
    @bg_positions.each do |x|
      @bg.draw(x, 0, ZOrder::BACKGROUND, @bg_scale, @bg_scale)
    end
  end
end
