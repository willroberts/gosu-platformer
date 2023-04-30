# frozen_string_literal: true

require 'forwardable'

# TODO: Remove game state? Access things via GameWindow->CorrectClass->Attribute instead.
class GameState
  extend Forwardable
  def_delegators :@state, :[], :[]=
  attr_accessor :current_stage, :choices, :input_locked, :advancing, :tutorial_done, :on_title_screen, :success, :failure

  def self.from_savefile(savefile_path)
    parsed = JSON.parse(savefile_path)
    new(state_hash: parsed)
  end

  def initialize(state_hash: {})
    @state = state_hash

    @current_stage = 0
    @choices = []
    @input_locked = true
    @advancing = false
    @on_title_screen = true
    @tutorial_done = false # Starts the game.

    @success = false
    @failure = false
  end
end
