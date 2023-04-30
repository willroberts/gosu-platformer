# frozen_string_literal: true

class Level1
  attr_reader :potion_positions, :spike_positions

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

    # Potions!
    @potion_sprite = Gosu::Image.new('sprites/items/potionRed.png', tileable: false)
    @potion_positions = [
      [1060, 570]
    ]

    # Floor spikes!
    @spike_sprite = Gosu::Image.new('sprites/environment/spikes.png', tileable: false)
    @spike_positions = [
      [510, 554]
    ]
  end

  # Triggered by player input.
  def advance_stage!
    state = GameWindow.game_state

    Thread.new do
      sleep GameWindow.advance_duration
      state.advancing = false
      state.input_locked = complete?
      @stage = next_stage
    end

    state.advancing = true
    next_elevations
  end

  def complete? = @stage == 6

  def next_stage = clamped_stage(@stage + 1)

  def next_elevations = @elevation_map[next_stage]

  def clamped_stage(candidate_stage)
    candidate_stage.clamp(*@elevation_map.keys.minmax_by { |k, _v| k })
  end

  def update
    # Move the character to the right by moving the level to the left.
    @level_pos_x -= @fg_speed
    @spike_positions.each.with_index { |coords, i|
      x, y = coords
      x -= @fg_speed
      @spike_positions[i] = x, y
    }
    @potion_positions.each.with_index { |coords, i|
      x, y = coords
      x -= @fg_speed
      @potion_positions[i] = x, y
    }
    @bg_positions.map! { |x| x - @bg_speed }
  end

  def remove_potion(i)
    @potion_positions.delete_at(i)
  end

  def draw
    @bg_positions.each do |x|
      @bg.draw(x, 0, ZOrder::BACKGROUND, @bg_scale, @bg_scale)
    end
    @level_sprite.draw(@level_pos_x, 0, ZOrder::LEVEL, @level_scale, @level_scale)
    @spike_positions.each do |coords|
      x, y = coords
      @spike_sprite.draw(x, y, ZOrder::LEVEL, 0.75, 0.75)
    end
    @potion_positions.each do |coords|
      x, y = coords
      @potion_sprite.draw(x, y, ZOrder::LEVEL, 0.75, 0.75)
    end
  end
end
