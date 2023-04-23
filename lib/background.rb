# frozen_string_literal: true

require 'gosu'

module Background
  def self.initialize
    @sprite = Gosu::Image.new('sprites/background/colored_grass.png', tileable: true)
    @scale = 0.7032 # Scales 1024px to 720px. TODO: Make this dynamic.
    @pos_x = 0
    @speed = 2.0
  end

  def self.move_left
    @pos_x -= @speed
  end

  def self.move_right
    @pos_x += @speed
  end

  def self.draw
    @sprite.draw(@pos_x, 0, ZOrder::BACKGROUND, @scale, @scale)
  end
end
