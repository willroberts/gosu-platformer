# frozen_string_literal: true

require 'gosu'

BACKGROUND_SCALE = 0.7032 # Scales 1024px to 720px. TODO: Make this dynamic.

module Background
  # Loads the sprite into memory.
  def self.initialize
    @sprite = Gosu::Image.new('sprites/background/colored_grass.png', tileable: true)
  end

  # Handles positioning of the sprite.
  def self.update
    # TODO
  end

  # Draws the sprite to the screen.
  def self.draw
    @sprite.draw(0, 0, ZOrder::BACKGROUND, BACKGROUND_SCALE, BACKGROUND_SCALE)
  end
end
