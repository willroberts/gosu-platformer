# frozen_string_literal: true

require 'gosu'
require 'singleton'

module ZOrder
  BACKGROUND, LEVEL, PICKUPS, CHARACTER, UI_BACKDROP, UI = *0..5
end

class GameWindow < Gosu::Window
  include Singleton

  attr_reader :game_state, :root_dir, :level, :advance_duration, :ui, :character

  def self.root_dir = instance.root_dir
  def self.level = instance.level
  def self.advance_duration = instance.advance_duration
  def self.game_state = instance.game_state

  def initialize
    super 1280, 720, fullscreen: false
    self.caption = 'Gosu Platformer'

    @game_state = GameState.new
    @root_dir = File.dirname(File.expand_path(__FILE__), 2)
    @title_screen = TitleScreen.new
    @level = Level1.new
    @ui = UI.new

    @advance_distance = 426 # Pixels between each stage (72px * 6 blocks + buffer).
    advance_speed = 4.0 # Pixels per frame.
    @advance_duration = (@advance_distance / advance_speed) / 60 # Kinematics v=d/t. Scaled by framerate.

    # Music!
    @music = Gosu::Song.new('sounds/music.mp3')
    @music.play(looping=true)
  end

  def character
    # Starting at x:252 means we can consistently advance to the exact center of each stage.
    # The floor is at y:648, but we subtract 128px for the character sprite.
    @character ||= Character.new(252, 520)
  end

  def update
    # Process player input (keyboard and mouse).
    handle_input

    # Handle title screen.
    @title_screen.update if game_state.on_title_screen

    # Process turns.
    level.update if game_state.advancing && !game_state.on_title_screen && !game_state.failure # Prevent zerg strat to die on last turn and still win?

    # Process game over states (both win and loss).
    game_state.failure = character.detect_death
    if game_state.failure
      game_state.input_locked = true
    end
    game_state.success = nil
    if game_state.success
    end

    # Update player interactions every frame.
    character.detect_collision
    character.update_locomotion
  end

  def handle_input
    close if Gosu.button_down?(Gosu::KB_ESCAPE)
    require 'pry'; binding.pry if Gosu.button_down?(Gosu::KB_P)

    if game_state.on_title_screen
      if Gosu.button_down?(Gosu::MS_LEFT)
        # HACK: Using a thread to prevent a single click from spanning multiple frames.
        Thread.new do
          sleep 0.250
          game_state.on_title_screen = false
        end
      end
      return
    end

    # Handle tutorial click.
    if !game_state.tutorial_done && Gosu.button_down?(Gosu::MS_LEFT)
      game_state.tutorial_done = true
      game_state.input_locked = false
    end

    return if game_state.input_locked

    if Gosu.button_down?(Gosu::MS_LEFT)
      card = ui.action_for_coordinates(self.mouse_x, self.mouse_y)
      return if level.complete? || card.nil?

      game_state.input_locked = true # Unlocked when stage ends.
      character.perform(card)
      level.advance_stage! unless card.is_a?(ConcentrateCard)
    end
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
    if game_state.on_title_screen
      @title_screen.draw
    else
      level.draw
      character.draw
      ui.draw game_state
    end
  end
end
