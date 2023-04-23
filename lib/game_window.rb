# frozen_string_literal: true

require 'gosu'
require 'singleton'

require_relative './background'
require_relative './levels/level1'
require_relative './ui'

module ZOrder
  BACKGROUND, LEVEL, PICKUPS, CHARACTER, UI = *0..4
end

class GameWindow < Gosu::Window
  include Singleton

  attr_reader :game_state, :root_dir, :character, :current_level

  def self.root_dir = self.instance.root_dir
  def self.scene = self.instance.scene
  def self.colliding?(sprite, side:) = self.instance.colliding?(sprite, side: side)

  def initialize
    super 1280, 720, fullscreen: false
    self.caption = 'Gosu Platformer'

    @game_state = GameState.new
    @root_dir = File.dirname(File.expand_path(__FILE__), 2)
    @current_level = Level1
    @collidables = []
    
    Background.initialize
    @current_level.initialize
    UI.initialize
  end

  def update
    handle_input
  end

  def draw
    Background.draw
    @current_level.draw
    character.draw
    UI.draw
  end

  def character
    # The floor is at y:648, but we subtract 128px for the character sprite.
    @character ||= Character.new(256, 520).tap {|c| @collidables << c }
  end

  def colliding?(sprite, side:)
    true if side == :bottom
    # @collidables.pairs, see if they overlap
  end

  def handle_input
    close if Gosu.button_down?(Gosu::KB_ESCAPE)

    if Gosu.button_down?(Gosu::KB_LEFT)
      Background.move_right
      @current_level.move_right
      character.update(:walk_left)
    end

    if Gosu.button_down?(Gosu::KB_RIGHT)
      Background.move_left
      @current_level.move_left
      character.update(:walk_right)
    end

    if !Gosu.button_down?(Gosu::KB_LEFT) && !Gosu.button_down?(Gosu::KB_RIGHT)
      character.update(:stop_walk)
    end

    if Gosu.button_down?(Gosu::KB_SPACE)
      character.update(:jump)
    end
  end
end
