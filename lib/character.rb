# frozen_string_literal: true

class Character
  attr_reader :x, :y, :sprite, :x_scale, :y_scale

  def initialize(x, y)
    @window = GameWindow.instance

    set_sprite 'alienBlue_stand.png'
    @walk_anim = Gosu::Image.load_tiles('sprites/character/animations/walk.png', 128, 256)

    @x, @y = x, y
    @x_accel, @y_accel = 0, 0
    @x_scale, @y_scale = 1, 1
    @speed = 0.0 # Visual trick while the level also moves.
  end

  def draw is_advancing
    if is_advancing
      walk
    else
      stop_walk
    end
    sprite.draw_rot(x, y, ZOrder::CHARACTER, 0, 0.5, 0.5, x_scale, y_scale)
  end

  def set_sprite(filename) = @sprite = Sprite.character(filename)

  def update(action)
    handle_gravity
    handle_action(action)
  end

  def handle_gravity
    # 9.8 m/s^2 leessgooo
    #   2 meters == 128px * 0.5 scale; 1 meter = 32px
    #   9.8 m/s^2 = 313.6px/s^2
    # return if some_condition?
    # @y += 10
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
    set_sprite(@walk_anim[Gosu.milliseconds / 100 % @walk_anim.size])
  end

  def stop_walk
    set_sprite('alienBlue_stand.png')
  end

  def jump
    set_sprite('alienBlue_jump.png')
    @y -= 10
  end
end
