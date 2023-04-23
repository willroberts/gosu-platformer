# frozen_string_literal: true

require 'gosu'
require 'singleton'

require_relative './background.rb'
require_relative './environment.rb'

module ZOrder
  BACKGROUND, ENVIRONMENT, PICKUPS, PLAYER, HUD = *0..4
end

class GameWindow < Gosu::Window
  include Singleton

  attr_reader :game_state, :root_dir, :character

  def self.root_dir = self.instance.root_dir
  def self.scene = self.instance.scene
  def self.colliding?(sprite, side:) = self.instance.colliding?(sprite, side: side)

  def initialize
    super 1280, 720, fullscreen: false
    self.caption = 'Gosu Platformer'

    @game_state = GameState.new
    @root_dir = File.dirname(File.expand_path(__FILE__), 2)
    @collidables = []
    
    Background.initialize
    Environment.initialize
  end

  def update
    character.update(:walk_left) if Gosu.button_down?(Gosu::KB_LEFT)
    character.update(:walk_right) if Gosu.button_down?(Gosu::KB_RIGHT)
    character.update(:jump) if Gosu.button_down?(Gosu::KB_SPACE)
    
    ### Adding input keybinds to test parallax. Can delete this.
    if Gosu.button_down? Gosu::KB_LEFT
      Background.move_right
      Environment.move_right
    end
    if Gosu.button_down? Gosu::KB_RIGHT
      Background.move_left
      Environment.move_left
    end
    ###
  end

  def draw
    Background.draw
    Environment.draw
    character.draw
  end

  def character
    @character ||= Character.new(200, 400).tap {|c| @collidables << c }
  end

  def colliding?(sprite, side:)
    true if side == :bottom
    # @collidables.pairs, see if they overlap
  end
end