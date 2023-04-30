# frozen_string_literal: true

require 'gosu'
require 'pry'
require 'singleton'

module ZOrder
  BACKGROUND, LEVEL, PICKUPS, CHARACTER, UI_BACKDROP, UI = *0..5
end

class GameWindow < Gosu::Window
  include Singleton

  attr_reader :advance_duration, :level, :root_dir, :tutorial_done, :ui
  attr_accessor :advancing, :input_locked

  def initialize
    super 1280, 720, fullscreen: false
    self.caption = 'Gosu Platformer'

    @root_dir = File.dirname(File.expand_path(__FILE__), 2)
    @title_screen = TitleScreen.new
    @level = Level1.new
    @ui = UI.new

    @input_locked = false
    @on_title_screen = true
    @tutorial_done = false

    @advancing = false
    @advance_distance = 426 # Pixels between each stage (72px * 6 blocks + buffer).
    advance_speed = 4.0 # Pixels per frame.
    @advance_duration = (@advance_distance / advance_speed) / 60 # Kinematics: v=d/t. Scaled by framerate.

    # Music!
    @music = Gosu::Song.new('sounds/music.mp3')
    @music.play(looping = true)
  end

  def self.advance_duration = instance.advance_duration
  def self.level = instance.level
  def self.root_dir = instance.root_dir

  def player
    # Starting at x:252 means we can consistently advance to the exact center of each stage.
    # The floor is at y:648, but we subtract 128px for the player sprite.
    @player ||= Player.new(252, 520)
  end

  def update
    # Process player input (keyboard and mouse).
    handle_input

    # Handle title screen.
    @title_screen.update if @on_title_screen

    # Process game over states (both win and loss).
    player.detect_death
    @input_locked = true if player.dead

    # Process turns.
    level.update if advancing && !@on_title_screen && !player.dead

    # Update player interactions every frame.
    player.detect_collision
    player.update_locomotion
  end

  def handle_input
    close if Gosu.button_down?(Gosu::KB_ESCAPE)
    binding.pry if Gosu.button_down?(Gosu::KB_P)

    if @on_title_screen
      if Gosu.button_down?(Gosu::MS_LEFT)
        Thread.new do
          # Prevent a single click from spanning multiple frames.
          sleep 0.250
          @on_title_screen = false
        end
      end
      return
    end

    # Handle tutorial click.
    if !@tutorial_done && Gosu.button_down?(Gosu::MS_LEFT)
      @tutorial_done = true
      @input_locked = false
    end

    return if @input_locked

    if Gosu.button_down?(Gosu::MS_LEFT)
      card = ui.action_for_coordinates(mouse_x, mouse_y)
      return if level.complete? || card.nil?

      @input_locked = true # Unlocked when stage ends.
      player.handle_action(card)
      level.advance_stage! unless card.is_a?(ConcentrateCard)
    end
  end

  # Triggered by player input.
  def skip_stage
    Thread.new do
      sleep 0.75
      @input_locked = false
    end

    @input_locked = true
  end

  def draw
    if @on_title_screen
      @title_screen.draw
    else
      level.draw
      player.draw
      ui.draw
    end
  end
end
