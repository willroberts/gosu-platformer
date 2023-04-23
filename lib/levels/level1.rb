# frozen_string_literal: true

require 'gosu'

module Level1
  def self.initialize
    @sprite = Gosu::Image.new('sprites/levels/level1.png', tileable: false)
    @scale = 0.5625 # 1280px to 720px. TODO: Make this dynamic.

    # The level currently moves instead of the player.
    @speed = 4.0
    @pos_x = 0

    # Store platform coordinates for this level.
    # Original scale: 5120x1280px. Game scale: 2880x720px. (56.25%)
    # Due to scaling, each block is 72x72px instead of 128x128px.
    # Multiply array elements by block size to get pixel coordinates.
    # We can use this to spawn sprites for collision detection.
    @platforms = [
      [0, 9, 40, 10], # Floor
      [7, 6, 24, 7],  # Platform 1
      [13, 3, 18, 4], # Platform 2
      [19, 6, 24, 7], # Platform 3
      [25, 3, 30, 4], # Platform 4
      [31, 6, 36, 7]  # Platform 5
    ]
  end

  def self.move_left
    @pos_x -= @speed
  end

  def self.move_right
    @pos_x += @speed
  end

  def self.draw
    @sprite.draw(@pos_x, 0, ZOrder::LEVEL, @scale, @scale)
  end
end
