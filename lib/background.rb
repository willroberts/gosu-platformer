# frozen_string_literal: true

require 'gosu'

BACKGROUND_SCALE = 0.7032 # Scales 1024px to 720px. TODO: Make this dynamic.
BACKGROUND_SPEED = 2.0

module Background
  def self.initialize
    @sprite = Gosu::Image.new('sprites/background/colored_grass.png', tileable: true)
    @pos_x = 0
  end

  def self.move_left
    @pos_x -= BACKGROUND_SPEED
  end

  def self.move_right
    @pos_x += BACKGROUND_SPEED
  end

  def self.draw
    @sprite.draw(@pos_x, 0, ZOrder::BACKGROUND, BACKGROUND_SCALE, BACKGROUND_SCALE)
  end
end
