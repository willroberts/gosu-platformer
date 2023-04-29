# frozen_string_literal: true

class Level1
  def initialize
    @level_sprite = Gosu::Image.new('sprites/levels/level1.png', tileable: true)
    @level_scale = 0.5625 # 1280px to 720px.
    @level_pos_x = 0
    @stage = 0

    # Parallax background.
    @bg = Gosu::Image.new('sprites/background/colored_grass.png', tileable: true)
    @bg_scale = 0.7032 # 1024px to 720px.
    @bg_positions = (-1..3).map { |x| x * 720 }
    @bg_speed = 2.0
    @fg_speed = 4.0

    # The level grid keeps track of all possible stages, platforms, enemies, potions, etc.
    @grid = Grid.new(6, 3)
    @grid.add_platforms([0, 0],
                        [1, 0], [1, 1],
                        [2, 0], [2, 2],
                        [3, 0], [3, 1],
                        [4, 0], [4, 2],
                        [5, 0], [5, 1],
                        [6, 0])
    @grid.add_enemies([1, 1])
    @grid.add_potions([2, 1])

    # elevation_map tracks whether or not each elevation has a standable platform/surface.
    @elevation_map = {
      0 => [true, false, false], # Starting stage, not accessed.
      1 => [true, true, false],
      2 => [true, false, true],
      3 => [true, true, false],
      4 => [true, false, true],
      5 => [true, true, false],
      6 => [true, false, false]
    }

    # Floor spikes!
    @spike_sprite = Gosu::Image.new('sprites/environment/spikes.png', tileable: false)
    @spike_positions = [530]

    # Potions!
    @potion_sprite = Gosu::Image.new('sprites/items/potionRed.png', tileable: false)
    @potion_positions = [1060]
  end

  def advance_stage!
    @stage = clamped_stage(@stage + 1)
  end

  def complete?
    @stage == 6
  end

  def next_elevations
    @elevation_map[clamped_stage(@stage + 1)]
  end

  def clamped_stage(candidate_stage)
    candidate_stage.clamp(*@elevation_map.keys.minmax_by { |k, _v| k })
  end

  def update
    # Move the character to the right by moving the level to the left.
    @level_pos_x -= @fg_speed
    @spike_positions.map! { |x| x -= @fg_speed }
    @potion_positions.map! { |x| x - @fg_speed }
    @bg_positions.map! { |x| x - @bg_speed }
  end

  def draw
    @bg_positions.each do |x|
      @bg.draw(x, 0, ZOrder::BACKGROUND, @bg_scale, @bg_scale)
    end
    @level_sprite.draw(@level_pos_x, 0, ZOrder::LEVEL, @level_scale, @level_scale)
    @spike_positions.each do |x|
      @spike_sprite.draw(x, 554, ZOrder::LEVEL, 0.75, 0.75)
    end
    @potion_positions.each do |x|
      @potion_sprite.draw(x, 570, ZOrder::LEVEL, 0.75, 0.75)
    end
  end
end
