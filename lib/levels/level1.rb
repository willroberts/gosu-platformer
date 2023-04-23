# frozen_string_literal: true

require 'gosu'

module Level1
  def self.initialize
    @sprite = Gosu::Image.new('sprites/levels/level1.png', tileable: false)
    @scale = 0.5625 # 1280px to 720px. TODO: Make this dynamic.

    # The level currently moves instead of the player.
    @speed = 4.0
    @pos_x = 0

    # Store collision coordinates for this level.
    # Original scale: 5120x1280px. Game scale: 2560x640px.
    @collisions = [
      [0, 576, 2560, 640],    # Floor
      [448, 384, 1536, 448],  # Platform 1
      [832, 192, 1152, 256],  # Platform 2
      [1216, 384, 1536, 448], # Platform 3
      [1600, 192, 1920, 256], # Platform 4
      [1984, 384, 2304, 448]  # Platform 5
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
