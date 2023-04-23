# frozen_string_literal: true

require 'gosu'

module UI
  def self.initialize
    @font = Gosu::Font.new(20)
    @enable_debug_grid = false
  end

  def self.update
  end

  def self.draw
    @font.draw_text("Press W to advance to the next stage", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
    @font.draw_text("Press ESC to quit", 10, 40, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)

    if @enable_debug_grid
      self.draw_debug_grid
    end
  end

  # Draws a grid of columns (x values) and rows (y values) for checking pixel precision.
  def self.draw_debug_grid
      72.step(1280, 72).each do |x|
        Gosu.draw_line(
          x, 0, Gosu::Color::BLACK,
          x, 720, Gosu::Color::BLACK
        )
      end
      72.step(720, 72).each do |y|
        Gosu.draw_line(
          0, y, Gosu::Color::BLACK,
          1280, y, Gosu::Color::BLACK
        )
      end
  end
end
