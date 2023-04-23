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
      walk(:right)
    else
      stop_walk
    end
    sprite.draw_rot(x, y, ZOrder::CHARACTER, 0, 0.5, 0.5, x_scale, y_scale)
  end

  def set_sprite(filename) = @sprite = Sprite.character(filename)

  def update(action)
    #handle_gravity
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
    when :jump then jump
    when :walk_left then walk(:left)
    when :walk_right then walk(:right)
    when :stop_walk then stop_walk
    else raise "unknown action! (#{action})"
    end
  end

  def jump
    set_sprite('alienBlue_jump.png')
    @y -= 10
  end

  def walk(direction)
    sprite = @walk_anim[Gosu.milliseconds / 100 % @walk_anim.size]
    set_sprite(sprite)
    #set_sprite('alienBlue_walk1.png')
    #set_direction(direction)
    #@x += direction == :right ? @speed : -@speed
  end

  def stop_walk
    set_sprite('alienBlue_stand.png')
  end

  def set_direction(direction)
    case direction
    when :left then @x_scale = -1
    when :right then @x_scale = 1
    else raise "unknown direction! (#{direction})"
    end
  end
end
