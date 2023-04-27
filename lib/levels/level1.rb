# frozen_string_literal: true

module Level1
  def self.initialize
    @level_sprite = Gosu::Image.new('sprites/levels/level1.png', tileable: true)
    @level_scale = 0.5625 # 1280px to 720px.
    @level_pos_x = 0

    # Parallax background.
    @bg = Gosu::Image.new('sprites/background/colored_grass.png', tileable: true)
    @bg_scale = 0.7032 # 1024px to 720px.
    @bg_positions = (-1..3).map { |x| x * 720 }
    @bg_speed = 2.0
    @fg_speed = 4.0

    # elevation_map tracks whether or not each elevation has a standable platform/surface.
    @elevation_map = {
      1 => [true, true, false],
      2 => [true, false, true],
      3 => [true, true, false],
      4 => [true, false, true],
      5 => [true, true, false],
      6 => [true, false, false]
    }

    # Floor spikes!
    @spike_sprite = Gosu::Image.new('sprites/environment/spikes.png', tileable: false)
    @spike_pos_x = 530

    # Potions!
    @potion_sprite = Gosu::Image.new('sprites/items/potionRed.png', tileable: false)
    @potion_pos_x = 1060
  end

  def self.get_next_elevations(stage)
    @elevation_map[clamped_stage(stage+1)]
  end

  def self.clamped_stage(candidate_stage)
    candidate_stage.clamp(*@elevation_map.keys.minmax_by{|k, _v| k })
  end

  def self.update(game_state) # FIXME: Stop passing game state everywhere lol.
    return unless game_state.advancing

    # Move the character to the right by moving the level to the left.
    @level_pos_x -= @fg_speed
    @spike_pos_x -= @fg_speed
    @potion_pos_x -= @fg_speed
    @bg_positions.map! { |x| x - @bg_speed }
  end

  def self.draw
    @bg_positions.each do |x|
      @bg.draw(x, 0, ZOrder::BACKGROUND, @bg_scale, @bg_scale)
    end
    @level_sprite.draw(@level_pos_x, 0, ZOrder::LEVEL, @level_scale, @level_scale)
    @spike_sprite.draw(@spike_pos_x, 554, ZOrder::LEVEL, 0.75, 0.75)
    @potion_sprite.draw(@potion_pos_x, 570, ZOrder::LEVEL, 0.75, 0.75)
  end
end
