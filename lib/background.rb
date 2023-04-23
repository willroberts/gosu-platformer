# frozen_string_literal: true

require 'gosu'

module Background
  def self.initialize
    @sprite = Gosu::Image.new('sprites/background/colored_grass.png', tileable: true)
    @scale = 0.7032 # Scales 1024px to 720px. TODO: Make this dynamic.
    @positions = [-1, 0, 1, 2, 3].map {|x| x * 720}
    @speed = 2.0
  end

  def self.move_left
    @positions.map! {|x| x -= @speed}
  end

  def self.move_right
    @positions.map! {|x| x += @speed}
  end

  def self.draw
    @positions.each do |x|
      @sprite.draw(x, 0, ZOrder::BACKGROUND, @scale, @scale)
    end
  end
end
