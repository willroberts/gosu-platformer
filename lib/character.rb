# frozen_string_literal: true

class Character
  attr_reader :x, :y, :sprite, :x_scale, :y_scale

  def initialize(x, y)
    @window = GameWindow.instance
    @x, @y = x, y
    @x_accel, @y_accel = 0, 0
    @x_scale, @y_scale = 1, 1
    @speed = 0.0 # Visual trick while the level also moves.
    @solid_footing = true
    set_sprite 'alienBlue_stand.png'
  end

  def draw = sprite.draw_rot(x, y, ZOrder::CHARACTER, 0, 0.5, 0.5, x_scale, y_scale)

  def set_sprite(filename) = @sprite = Sprite.character(filename)

  def update(action)
    handle_gravity
    handle_action(action)
  end

  def handle_gravity
    # 9.8 m/s^2 leessgooo
    return if solid_footing?
    @y += 10
  end

  def solid_footing?
    # Detect collision with the game window.
    if GameWindow.colliding?(self, side: :bottom)
      true
    end

    # Detect collision with platforms in the level.
    # FIXME: Can't access current_level.
    #GameWindow.current_level.platforms.each do |p|
    #  puts p
    #end
  end

  def handle_action(action)
    case action
    when :jump then jump
    when :walk_left then walk(:left)
    when :walk_right then walk(:right)
    else raise "unknown action! (#{action})"
    end
  end

  def jump
    set_sprite('alienBlue_jump.png')
    @y -= 10
  end

  def walk(direction)
    set_sprite('alienBlue_walk1.png')
    set_direction(direction)
    @x += direction == :right ? @speed : -@speed
  end

  def set_direction(direction)
    case direction
    when :left then @x_scale = -1
    when :right then @x_scale = 1
    else raise "unknown direction! (#{direction})"
    end
  end
end
