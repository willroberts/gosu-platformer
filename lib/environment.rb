# frozen_string_literal: true

require 'gosu'

ENVIRONMENT_SCALE = 0.5625 # 1280px to 720px. TODO: Make this dynamic based on screen resolution.

module Environment
  # Loads the sprite into memory.
  def self.initialize
    @sprite = Gosu::Image.new('sprites/levels/level1.png', tileable: false)
  end

  # Handles positioning of the sprite.
  def self.update
    # TODO
  end

  # Draws the sprite to the screen.
  def self.draw
    @sprite.draw(0, 0, ZOrder::ENVIRONMENT, ENVIRONMENT_SCALE, ENVIRONMENT_SCALE)
  end
end
