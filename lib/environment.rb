# frozen_string_literal: true

require 'gosu'

ENVIRONMENT_SCALE = 0.5625 # 1280px to 720px. TODO: Make this dynamic.
ENVIRONMENT_SPEED = 4.0

module Environment
  def self.initialize
    @sprite = Gosu::Image.new('sprites/levels/level1.png', tileable: false)
    @pos_x = 0
  end

  def self.move_left
    @pos_x -= ENVIRONMENT_SPEED
  end

  def self.move_right
    @pos_x += ENVIRONMENT_SPEED
  end

  def self.draw
    @sprite.draw(@pos_x, 0, ZOrder::ENVIRONMENT, ENVIRONMENT_SCALE, ENVIRONMENT_SCALE)
  end
end
