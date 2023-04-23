# frozen_string_literal: true

require 'gosu'

module Level1
  def self.initialize
    @sprite = Gosu::Image.new('sprites/levels/level1.png', tileable: false)
    @scale = 0.5625 # 1280px to 720px. TODO: Make this dynamic.

    # The level currently moves instead of the player.
    @speed = 4.0
    @pos_x = 0

    # Each level has 5 stages and 3 elevations (for now).
    @elevations = [520, 304, 88]
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
