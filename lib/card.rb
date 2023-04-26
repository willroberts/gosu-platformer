class Card
  attr_reader :action, :text, :icon, :desc

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
    @text = "Walk"
    @icon = nil
    @desc = "Move forward without jumping."
  end
end

class JumpCard < Card
  def initialize
    super

    @action = :jump
    @text = "Jump"
    @icon = nil
    @desc = "Jump and move forward."
  end
end

class RestCard < Card
  def initialize
    super

    @action = :rest
    @text = "Rest"
    @icon = nil
    @desc = "Pass the turn, regaining 1 HP."
  end
end
