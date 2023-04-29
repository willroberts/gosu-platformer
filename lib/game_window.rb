# frozen_string_literal: true

require 'gosu'
require 'singleton'

module ZOrder
  BACKGROUND, LEVEL, PICKUPS, CHARACTER, UI_BACKDROP, UI = *0..5
end

class GameWindow < Gosu::Window
  include Singleton

  attr_reader :game_state, :root_dir, :current_level, :advance_duration, :ui

  def self.root_dir = instance.root_dir
  def self.scene = instance.scene

  def initialize
    super 1280, 720, fullscreen: false
    self.caption = 'Gosu Platformer'

    @game_state = GameState.new
    game_state.choices = [WalkCard.new, JumpCard.new, RestCard.new] # TODO: Move this to the right place.

    @root_dir = File.dirname(File.expand_path(__FILE__), 2)
    @current_level = Level1.new
    @ui = UI.new

    @advance_distance = 422 # Pixels between each stage (72px * 6 blocks).
    advance_speed = 4.0 # Pixels per frame.
    @advance_duration = (@advance_distance / advance_speed) / 60 # Kinematics v=d/t. Scaled by framerate.
  end

  def character
    # Starting at x:252 means we can consistently advance to the exact center of each stage.
    # The floor is at y:648, but we subtract 128px for the character sprite.
    @character ||= Character.new(252, 520)
  end

  def update
    handle_input
    current_level.update if game_state.advancing
    character.update_locomotion
  end

  def handle_input
    close if Gosu.button_down?(Gosu::KB_ESCAPE)

    # Handle tutorial click.
    if !game_state.tutorial_done && Gosu.button_down?(Gosu::MS_LEFT)
      game_state.tutorial_done = true
      game_state.input_locked = false
    end

    return if game_state.input_locked

    if Gosu.button_down?(Gosu::MS_LEFT)
      choice = determine_click_location(self.mouse_x, self.mouse_y)
      return if choice.negative? # Nothing clicked.

      game_state.input_locked = true
      action = game_state.choices[choice].action
      character.perform(action)
    end
  end

  def determine_click_location(x, y)
    offset = 128
    y_static = 40

    if y.between?(y_static, y_static + offset)
      return 0 if x.between?(400, 400 + offset)
      return 1 if x.between?(576, 576 + offset)
      return 2 if x.between?(752, 752 + offset)
    end

    -1
  end

  # Triggered by player input.
  def advance_stage
    Thread.new do
      sleep @advance_duration
      game_state.advancing = false
      game_state.input_locked = false
      current_level.advance_stage!

      if current_level.complete?
        game_state.input_locked = true
        game_state.level_done = true
      end
    end

    game_state.advancing = true
    current_level.next_elevations
  end

  # Triggered by player input.
  def skip_stage
    Thread.new do
      sleep 1
      game_state.input_locked = false
    end

    game_state.input_locked = true
  end

  def draw
    current_level.draw
    character.draw
    ui.draw game_state
  end
end
