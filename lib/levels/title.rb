# frozen_string_literal: true

class TitleScreen
  def initialize
    @bg = Gosu::Image.new('sprites/background/colored_grass.png', tileable: true)
    @bg_scale = 0.7032 # 1024px to 720px.
    @bg_positions = (-1..64).map { |x| x * 720 } # Enough background for ~12 minutes before we scroll off-screen.
    @bg_speed = 1.0

    @logo = Gosu::Image.new('sprites/logo.png', tileable: false)

    @title_font = Gosu::Font.new(64)
    @sub_font = Gosu::Font.new(32)
  end

  def update
    @bg_positions.map! { |x| x - @bg_speed }
  end

  def draw
    @bg_positions.each do |x|
      @bg.draw(x, 0, ZOrder::BACKGROUND, @bg_scale, @bg_scale)
    end

    @logo.draw(100, 200, ZOrder::UI, 1.0, 1.0)

    @sub_font.draw_text('By Tyler and Will', 530, 320, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
    @sub_font.draw_text('Click anywhere to play', 500, 550, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
  end
end
