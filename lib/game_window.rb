# frozen_string_literal: true

require 'gosu'
require 'singleton'

module ZOrder
  BACKGROUND, LEVEL, PICKUPS, CHARACTER, UI = *0..4
end

class GameWindow < Gosu::Window
  include Singleton

  attr_reader :game_state, :root_dir, :current_level, :advance_duration

  def self.root_dir = instance.root_dir
  def self.scene = instance.scene

  def initialize
    super 1280, 720, fullscreen: false
    self.caption = 'Gosu Platformer'

    @game_state = GameState.new
    @game_state.choices = [WalkCard.new, JumpCard.new, RestCard.new] # TODO: Move this to the right place.

    @root_dir = File.dirname(File.expand_path(__FILE__), 2)
    @current_level = Level1

    @current_level.initialize
    UI.initialize

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
    @current_level.update
    @game_state.current_stage = @current_level.get_stage
    character.update_locomotion
  end

  def handle_input
    close if Gosu.button_down?(Gosu::KB_ESCAPE)

    return if @game_state.input_locked

    if Gosu.button_down?(Gosu::MS_LEFT)
      choice = determine_click_location(self.mouse_x, self.mouse_y)
      return if choice.negative? # Nothing clicked.
      puts "Card #{choice} clicked"

      @game_state.input_locked = true
      action = @game_state.choices[choice].action
      character.perform(action)
    end

    #character.perform(:walk) if Gosu.button_down?(Gosu::KB_W)
    #character.perform(:jump) if Gosu.button_down?(Gosu::KB_SPACE)
  end

  def determine_click_location(x, y)
    return 0 if x >= 400 && x <= 400+128 && y >= 40 && y <= 40+128
    return 1 if x >= 576 && x <= 576+128 && y >= 40 && y <= 40+128
    return 2 if x >= 752 && x <= 752+128 && y >= 40 && y <= 40+128
    return -1 # Nothing clicked.
  end

  # Triggered by player input.
  # FIXME: There is a timer in lib/levels/level1.rb which handles advancing the stage.
  # We should move this timer here so we can do more callback-type things with it.
  # For example, we need to disable input handling until advancing the stage (movement, animations) is done.
  def advance_stage
    Thread.new do
      sleep @advance_duration
      @game_state.advancing = false
      @game_state.input_locked = false
      @game_state.current_stage += 1
    end

    @game_state.advancing = true
    @current_level.advance_stage
  end

  def draw
    @current_level.draw
    character.draw
    UI.draw @game_state
  end
end
