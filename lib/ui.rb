# frozen_string_literal: true

require 'gosu'

module UI
  def self.initialize
    @font = Gosu::Font.new(20)
  end

  def self.update
  end

  def self.draw
    @font.draw_text("Press W to move forward", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
    @font.draw_text("Press SPACE to jump", 10, 40, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
  end
end
