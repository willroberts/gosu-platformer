# frozen_string_literal: true

require 'forwardable'

class GameState
  extend Forwardable
  def_delegators :@state, :[], :[]=
  attr_accessor :current_stage, :choices, :input_locked, :advancing

  def self.from_savefile(savefile_path)
    parsed = JSON.parse(savefile_path)
    new(state_hash: parsed)
  end

  def initialize(state_hash: {})
    @state = state_hash

    # TODO: I'm just adding stuff here WILLY NILLY but I'm probably using this class wrong.
    @current_stage = 0
    @choices = []
    @input_locked = false
    @advancing = false
  end
end
