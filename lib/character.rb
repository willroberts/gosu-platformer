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
    elsif @is_jumping || @is_falling
      v = vert_velocity
      @y -= v
      if v < 0
        # We are now falling.
        @is_jumping = false
        @is_falling = true

        # Stop falling when we hit the ground.
        if @y >= 520
          @y = 520
          @is_falling = false
          reset_sprite
        end
      end
    end
  end

  def walk
    return if @is_walking

    Thread.new do
      sleep @walk_duration
      @is_walking = false
      reset_sprite
    end

    @is_walking = true
    @window.advance_stage
  end

  def jump
    return if @is_jumping || @is_falling

    @is_jumping = true
    set_sprite('alienBlue_jump.png')
    @window.advance_stage
    @jump_start_time = Time.now
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
