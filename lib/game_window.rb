# frozen_string_literal: true

require 'gosu'
require_relative './background.rb'
require_relative './environment.rb'

module ZOrder
  BACKGROUND, ENVIRONMENT, PICKUPS, PLAYER, HUD = *0..4
end

class GameWindow < Gosu::Window
  def initialize
    super 1280, 720, fullscreen: false
    self.caption = 'Gosu Platformer'

    Background.initialize
    Environment.initialize
  end

  def update
    Background.update
    Environment.update
  end

  def draw
    Background.draw
    Environment.draw
  end
end
