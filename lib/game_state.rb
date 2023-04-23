# frozen_string_literal: true

require 'forwardable'

class GameState
  extend Forwardable
  def_delegators :@state, :[], :[]=

  def self.from_savefile(savefile_path)
    parsed = JSON.parse(savefile_path)
    new(state_hash: parsed)
  end

  def initialize(state_hash: {})
    @state = state_hash
  end
end
