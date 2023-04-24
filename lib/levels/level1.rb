# frozen_string_literal: true

module Level1
  def self.initialize
    @sprite = Gosu::Image.new('sprites/levels/level1.png', tileable: true)
    @scale = 0.5625 # 1280px to 720px.

    # Parallax background.
    @bg = Gosu::Image.new('sprites/background/colored_grass.png', tileable: true)
    @bg_scale = 0.7032 # 1024px to 720px.
    @bg_positions = (-1..3).map { |x| x * 720 }
    @bg_speed = 2.0

    # The level currently moves instead of the player.
    @pos_x = 0

    # Each level has 5 stages and 3 elevations (for now).
    @stage = 1
    @elevations = [520, 304, 88] # Pixels.

    # Advancing the stage triggers scene movement.
    @advancing = false
    @advance_speed = 4.0 # Pixels per frame.
    @advance_distance = 422 # Pixels between each stage (72px * 6 blocks).
    @advance_duration = (@advance_distance / @advance_speed) / 60 # Kinematics v=d/t. Scaled by framerate.
  end

  def self.advance_stage
    return if @advancing

    Thread.new do
      sleep @advance_duration
      @advancing = false
      @stage += 1
    end

    @advancing = true
  end

  # FIXME: Tried attr_reader but didn't work, might need a class instead of a module?
  def self.get_stage
    @stage
  end

  def self.update
    # Move the character to the right by moving the level to the left.
    return unless @advancing

    @pos_x -= @advance_speed
    @bg_positions.map! { |x| x -= @bg_speed }
  end

  def self.draw
    @bg_positions.each do |x|
      @bg.draw(x, 0, ZOrder::BACKGROUND, @bg_scale, @bg_scale)
    end
    @sprite.draw(@pos_x, 0, ZOrder::LEVEL, @scale, @scale)
  end
end
