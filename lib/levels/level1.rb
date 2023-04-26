# frozen_string_literal: true

module Level1
  def self.initialize
    @sprite = Gosu::Image.new('sprites/levels/level1.png', tileable: true)
    @scale = 0.5625 # 1280px to 720px.
    @pos_x = 0

    # Parallax background.
    @bg = Gosu::Image.new('sprites/background/colored_grass.png', tileable: true)
    @bg_scale = 0.7032 # 1024px to 720px.
    @bg_positions = (-1..3).map { |x| x * 720 }
    @bg_speed = 2.0
    @fg_speed = 4.0

    # Each level has 5 stages and 3 elevations (for now).
    # elevation_map tracks whether or not each elevation has a standable platform/surface.
    @stage = 0
    @elevation_map = {
      1 => [true, true, false],
      2 => [true, false, true],
      3 => [true, true, false],
      4 => [true, false, true],
      5 => [true, true, false],
      6 => [true, false, false]
    }
  end

  def self.advance_stage
    return @elevation_map[clamped_stage(@stage)] if @advancing

    @elevation_map[clamped_stage(@stage + 1)]
  end

  def self.clamped_stage(candidate_stage)
    candidate_stage.clamp(*@elevation_map.keys.minmax_by{|k, _v| k })
  end

  # FIXME: Tried attr_reader but didn't work, might need a class instead of a module?
  def self.get_stage
    @stage
  end

  def self.update
    return unless @advancing

    # Move the character to the right by moving the level to the left.
    @pos_x -= @fg_speed
    @bg_positions.map! { |x| x - @bg_speed }
  end

  def self.draw
    @bg_positions.each do |x|
      @bg.draw(x, 0, ZOrder::BACKGROUND, @bg_scale, @bg_scale)
    end
    @sprite.draw(@pos_x, 0, ZOrder::LEVEL, @scale, @scale)
  end
end
