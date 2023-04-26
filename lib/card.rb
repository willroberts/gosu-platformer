class Card
  attr_reader :visible, :size, :text, :icon, :desc
  def new
    @visible = false
    @size = 128
    @text = ''
    @icon = nil
    @desc = ''

    puts 'initialized a card'
  end
end

class WalkCard < Card
  def new
    super

    @text = "Rest"
    @desc = "Move forward without jumping."

    puts 'initialized a walk card'
  end
end

class JumpCard < Card
  def new
    super

    @text = "Jump"
    @desc = "Jump and move forward."
  end
end

class RestCard < Card
  def new
    super

    @text = "Rest"
    @desc = "Pass the turn, regaining 1 HP."
  end
end
