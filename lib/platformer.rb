# frozen_string_literal: true

require 'gosu'

class GameWindow < Gosu::Window
  def initialize
    super 1280, 720, fullscreen: false
    self.caption = 'Gosu Platformer'
  end

  def update
  end

  def draw
  end
end
