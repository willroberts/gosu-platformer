# frozen_string_literal: true

class Character
  attr_reader :x, :y, :sprite, :x_scale, :y_scale

  def initialize(x, y)
    @window = GameWindow.instance

    set_sprite 'alienBlue_stand.png'
    @walk_anim = Gosu::Image.load_tiles('sprites/character/animations/walk.png', 128, 256)

    @x, @y = x, y
    @x_scale, @y_scale = 1, 1

    @jump_impulse = 10 # Pixels per frame.
    @jump_gravity = 313.6 # Pixels/Sec^2 (9.81m/s^2 with 1m=32px).
  end

  def draw is_advancing
    if is_advancing
      walk
    else
      stop_walk
    end
    sprite.draw_rot(x, y, ZOrder::CHARACTER, 0, 0.5, 0.5, x_scale, y_scale)
  end

  def set_sprite(filename, **opts) = @sprite = Sprite.character(filename, **opts)

  def update(action)
    handle_gravity
    handle_action(action)
  end

  def handle_gravity
    # return if some_condition? # TODO: Replace with platform/floor awareness.
    # @y += @jump_impulse # TODO: Replace with gravity acceleration.
  end

  def handle_action(action)
    case action
    when :walk then walk
    when :stop_walk then stop_walk
    when :jump then jump
    else raise "unknown action! (#{action})"
    end
  end

  def walk
    # Bypassing sprite cache: animations frames are already unique in memory.
    @sprite = @walk_anim[Gosu.milliseconds / 100 % @walk_anim.size]
  end

  def stop_walk
    set_sprite('alienBlue_stand.png')
  end

  def jump
    set_sprite('alienBlue_jump.png')
    @y -= @jump_impulse
  end
end
