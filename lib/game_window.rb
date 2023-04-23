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
    # Adding input keybinds to test parallax. Can delete this.
    if Gosu.button_down? Gosu::KB_LEFT
      Background.move_right
      Environment.move_right
    end

    if Gosu.button_down? Gosu::KB_RIGHT
      Background.move_left
      Environment.move_left
    end
  end

  def draw
    Background.draw
    Environment.draw
  end
end
