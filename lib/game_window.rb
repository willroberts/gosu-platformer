# frozen_string_literal: true

require 'gosu'
require 'singleton'

module ZOrder
  BACKGROUND, LEVEL, PICKUPS, CHARACTER, UI = *0..4
end

class GameWindow < Gosu::Window
  include Singleton

  attr_reader :game_state, :root_dir, :current_level

  def self.root_dir = instance.root_dir
  def self.scene = instance.scene

  def initialize
    super 1280, 720, fullscreen: false
    self.caption = 'Gosu Platformer'

    @game_state = GameState.new
    @root_dir = File.dirname(File.expand_path(__FILE__), 2)
    @current_level = Level1

    @current_level.initialize
    UI.initialize
  end

  def character
    # Starting at x:252 means we can consistently advance to the exact center of each stage.
    # The floor is at y:648, but we subtract 128px for the character sprite.
    @character ||= Character.new(252, 520)
  end

  def update
    handle_input
    @current_level.update
    character.update_locomotion
  end

  def handle_input
    close if Gosu.button_down?(Gosu::KB_ESCAPE)
    character.perform(:walk) if Gosu.button_down?(Gosu::KB_W)
    character.perform(:jump) if Gosu.button_down?(Gosu::KB_SPACE)
  end

  # Triggered by player input.
  def advance_stage
    @current_level.advance_stage
  end

  def draw
    @current_level.draw
    character.draw
    UI.draw @current_level.get_stage # FIXME: Find a better way to access this.
  end
end
