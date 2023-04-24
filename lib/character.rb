# frozen_string_literal: true

class Character
  attr_reader :x, :y, :sprite, :x_scale, :y_scale

  def initialize(x, y)
    @window = GameWindow.instance

    set_sprite('alienBlue_stand.png')
    @walk_anim = Gosu::Image.load_tiles('sprites/character/animations/walk.png', 128, 256)
    @walk_duration = 1.7583 # TODO: Reduce duplication with the math in Level1.
    @is_walking = false

    @x = x
    @y = y
    @x_scale = 1
    @y_scale = 1
    @floor_heights = [520, 304, 88] # 1F, 2F, 3F. Pixels.
    @current_elevation = 0 # 1F.

    @jump_impulse = 22.0 # Pixels per frame.
    @jump_gravity = 31.0 # Pixels per square second.
    @jump_start_time = nil
    @is_jumping = false
    @is_falling = false
  end

  def set_sprite(filename) = @sprite = Sprite.character(filename)

  ### Update Loop ###

  def perform(action)
    handle_action(action)
  end

  # Actions occur once per turn/stage.
  def handle_action(action)
    case action
    when :walk then walk
    when :jump then jump
    else raise "unknown action! (#{action})"
    end
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
          reset_sprite
        end
      end
    end
  end

  def walk
    return if @is_walking || @is_falling || @is_jumping

    Thread.new do
      sleep @walk_duration
      @is_walking = false
      reset_sprite
    end

    @is_walking = true

    next_elevations = @window.advance_stage
    if next_elevations.nil?
      puts 'next_elevations was nil!'
      return # FIXME: What's causing this?
    end

    # Handle falling off current elevation when walking.
    puts "[walk] Elevation before: #{@current_elevation}"
    if @current_elevation == 1 && !next_elevations[1]
      @current_elevation -= 1
      @is_falling = true
    elsif @current_elevation == 2 && !next_elevations[2]
      @current_elevation -= 1
      @is_falling = true
      unless next_elevations[1]
        @current_elevation -= 1
        @is_falling = true
      end
    end
    puts "[walk] Eleavtion after: #{@current_elevation}"
  end

  def jump
    return if @is_jumping || @is_falling || @is_walking

    @is_jumping = true
    @jump_start_time = Time.now
    set_sprite('alienBlue_jump.png')

    next_elevations = @window.advance_stage
    if next_elevations.nil?
      puts 'next_elevations was nil!'
      return # FIXME: What's causing this?
    end

    # Handle jumping to higher elevation.
    puts "[jump] Eleavtion before: #{@current_elevation}"
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
    puts "[jump] Eleavtion after: #{@current_elevation}"
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
    @sprite.draw_rot(x, y, ZOrder::CHARACTER, 0, 0.5, 0.5, x_scale, y_scale)
  end
end
