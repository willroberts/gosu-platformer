# frozen_string_literal: true

class Card
  attr_reader :action, :desc, :icon, :text

  def initialize
    @action = nil
    @text = ''
    @icon = nil
    @desc = '' # On hover (TBD).
  end
end

class WalkCard < Card
  def initialize
    super

    @action = :walk
    @text = 'Walk'
    @icon = nil
    @desc = 'Move forward without jumping.'
  end
end

class JumpCard < Card
  def initialize
    super

    @action = :jump
    @text = 'Jump'
    @icon = nil
    @desc = 'Jump and move forward.'
  end
end

class ConcentrateCard < Card
  def initialize
    super

    @action = :concentrate
    @text = 'Concentrate'
    @icon = nil
    @desc = 'Think hard and pass the turn.'
  end
end
