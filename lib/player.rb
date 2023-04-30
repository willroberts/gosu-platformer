# frozen_string_literal: true

class Player
  attr_reader :dead, :health

  def initialize(x, y)
    @x = x
    @y = y
    @x_scale = 1
    @y_scale = 1
    @floor_heights = [520, 304, 88] # 1F, 2F, 3F. Pixels.
    @current_elevation = 0 # 1F.

    set_sprite('alienBlue_stand.png')
    @walk_anim = Gosu::Image.load_tiles('sprites/character/animations/walk.png', 128, 256)
    @is_walking = false
    @walk_sound = Gosu::Sample.new('sounds/walk.mp3')

    @jump_impulse = 22.0 # Pixels per frame.
    @jump_gravity = 31.0 # Pixels per square second.
    @jump_start_time = nil
    @is_jumping = false
    @is_falling = false
    @jump_sound = Gosu::Sample.new('sounds/jump.mp3')

    @concentrate_sound = Gosu::Sample.new('sounds/concentrate.mp3')

    # Health and damage.
    @health = 5
    @dead = false
    @invulnerable = false
    @damage_sound = Gosu::Sample.new('sounds/damage.mp3')
  end

  def window
    GameWindow.instance
  end

  def set_sprite(filename) = @sprite = Sprite.character(filename)

  ### Update Loop ###

  # Actions occur once per turn/stage.
  def handle_action(action)
    case action
    when WalkCard then walk
    when JumpCard then jump
    when ConcentrateCard then concentrate
    else raise "unknown action! (#{action})"
    end
  end

  # Collision is performed via jank. Check bounds of sprites for spikes and potions.
  def detect_collision
    spikes = window.level.spike_positions
    spikes.each do |coords|
      x, y = coords
      next if @invulnerable

      next unless overlaps(x, y + 32, x + 96, y + 64)

      # Take damage.
      @health -= 1 unless @health <= 0
      @damage_sound.play(volume = 0.5)

      # Prevent taking damage for the time it takes to walk through the spikes.
      @invulnerable = true
      Thread.new do
        sleep 0.85 # Just enough time to avoid taking damage twice from one spike.
        @invulnerable = false
      end
    end

    potions = window.level.potion_positions
    potions.each.with_index do |coords, i|
      x, y = coords
      if overlaps(x, y, x + 96, y + 96)
        # Gain 1 HP.
        @health += 1 unless @health >= 5

        # Remove the potion from the level
        window.level.remove_potion(i)
      end
    end
  end

  def detect_death
    if @health <= 0
      @invulnerable = true
      @dead = true
      return true
    end
    false
  end

  # Detect player overlap with the given sprite bounds.
  def overlaps(x1, y1, x2, y2)
    # Determine player bounds.
    left_edge = @x - 56
    right_edge = @x + 56
    top_edge = @y - 24
    bottom_edge = @y + 128

    return true if right_edge >= x1 && left_edge <= x2 && bottom_edge >= y1 && top_edge <= y2

    false
  end

  # Locomotion is processed every frame.
  def update_locomotion
    if @is_walking
      # Bypassing sprite cache: animation frames are already unique in memory.
      @sprite = @walk_anim[Gosu.milliseconds / 100 % @walk_anim.size]
    end

    if @is_jumping || @is_falling
      v = vert_velocity
      @y -= v
      if v.negative?
        # We are now falling.
        @is_jumping = false
        @is_falling = true

        # Stop falling when we hit the ground.
        if @y >= @floor_heights[@current_elevation]
          @y = @floor_heights[@current_elevation]
          @is_falling = false
          @is_walking = true
          Thread.new do
            # This value may need to be longer if traversing from higher->lower elevatioon (~0.6s)
            jitter = 0.4
            sleep(window.advance_duration / 2 - jitter)
            @is_walking = false
            reset_sprite
          end
        end
      end
    end
  end

  def walk
    return if @is_walking || @is_falling || @is_jumping

    Thread.new do
      sleep window.advance_duration
      @is_walking = false
      reset_sprite
    end

    @is_walking = true
    @walk_sound.play
    next_elevations = window.level.next_elevations

    # Handle falling off current elevation when walking.
    if @current_elevation == 1 && !next_elevations[1]
      delay_fall
    elsif @current_elevation == 2 && !next_elevations[2]
      delay_fall
      delay_fall unless next_elevations[1]
    end
  end

  def delay_fall
    Thread.new do
      sleep(window.advance_duration / 2 + 0.1)
      @current_elevation -= 1
      @is_falling = true
    end
  end

  def jump
    return if @is_jumping || @is_falling || @is_walking

    @is_jumping = true
    @jump_start_time = Time.now
    set_sprite('alienBlue_jump.png')
    @jump_sound.play

    next_elevations = window.level.next_elevations

    # Handle jumping to higher elevation.
    if @current_elevation.zero? && next_elevations[1]
      @current_elevation += 1
    elsif @current_elevation == 1 && next_elevations[2]
      @current_elevation += 1
    end

    # Handle falling off current elevation when jumping.
    if @current_elevation == 1 && (!next_elevations[1] && !next_elevations[2])
      @current_elevation -= 1
    elsif @current_elevation == 2 && !next_elevations[2]
      @current_elevation -= 1
      @current_elevation -= 1 unless next_elevations[1]
    end
  end

  def concentrate
    @concentrate_sound.play
    window.skip_stage
  end

  # Calculate vertical velocity based on jumping and falling durations.
  # Kinematics: v2 = v1 * at.
  def vert_velocity
    dt = Time.now - @jump_start_time
    downward_velocity = @jump_gravity * dt
    @jump_impulse - downward_velocity
  end

  def reset_sprite
    set_sprite('alienBlue_stand.png')
  end

  ### Draw Loop ###
  def draw
    # Make the player sprite flash when damage was taken.
    return if @invulnerable && (Gosu.milliseconds / 100).even?

    # Gosu.draw_rect(x-56, y-24, 112, 152, Gosu::Color::BLUE) # Debug box for collision.
    @sprite.draw_rot(@x, @y, ZOrder::CHARACTER, 0, 0.5, 0.5, @x_scale, @y_scale)
  end
end
