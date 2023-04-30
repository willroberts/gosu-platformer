# frozen_string_literal: true

class UI
  attr_reader :choices

  def initialize
    @hud_font = Gosu::Font.new(20)
    @big_font = Gosu::Font.new(64)
    @health_frame = Gosu::Image.new('sprites/hud/health_frame.png', tileable: false)
    @health_bar = Gosu::Image.new('sprites/hud/health_bar.png', tileable: false)
    @choice_sprite = Gosu::Image.new('sprites/hud/window.png', tileable: false)
    @choices = [WalkCard.new, JumpCard.new, ConcentrateCard.new]
    @enable_debug_grid = false
  end

  def window
    GameWindow.instance
  end

  def draw
    # Display health bar.
    @health_frame.draw(10, 10, ZOrder::UI, 0.5, 0.5)
    @health_bar.draw(20, 20, ZOrder::UI, window.player.health * 0.1, 0.5)

    # Tutorial window.
    unless window.tutorial_done
      draw_choice(x: 396, y: 266, x_scale: 0.6, y_scale: 0.6)
      hud_text('Welcome to the game!', x: 550, y: 310)
      hud_text('Play each turn by choosing from three action cards.', x: 430, y: 360)
      hud_text('Use movement and abilities to avoid taking damage.', x: 430, y: 390)
      hud_text('Heal yourself by collecting potions.', x: 430, y: 420)
      hud_text('Make it to the end of the level to win!', x: 430, y: 450)
      hud_text('Click anywhere to continue.', x: 530, y: 510)
    end

    # Card choices.
    unless window.input_locked
      if choices.length == 3
        sprite_constants = { y: 40, x_scale: 0.1559, y_scale: 0.2525 }

        draw_choice(x: 400, **sprite_constants)
        hud_text(choices[0].text, x: 400 + 44, y: 40 + 54)

        draw_choice(x: 576, **sprite_constants)
        hud_text(choices[1].text, x: 576 + 44, y: 40 + 54)

        draw_choice(x: 752, **sprite_constants)
        hud_text(choices[2].text, x: 722 + 44, y: 40 + 54)
      else
        raise 'Invalid number of choices!'
      end
    end

    # Game Over text.
    if GameWindow.level.complete?
      draw_choice(x: 436, y: 266, x_scale: 0.5, y_scale: 0.25) # Backdrop.
      @big_font.draw_text('You win!', 530, 290, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
      # hud_text('Click to play again.', x: 565, y: 355) # TODO: Add this feature.
      hud_text('Press ESC to quit.', x: 565, y: 355)
      window.input_locked = true # Hide choices.
    end

    if window.player.health.zero? # Player dead.
      draw_choice(x: 436, y: 266, x_scale: 0.5, y_scale: 0.25) # Backdrop.
      @big_font.draw_text('Game over!', 500, 290, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
      # hud_text('Click to play again.', x: 565, y: 355) # TODO: Add this feature.
      hud_text('Press ESC to quit.', x: 565, y: 355)
      window.input_locked = true # Hide choices.
    end

    # Level debug grid.
    draw_debug_grid if @enable_debug_grid
  end

  # Draws a grid of columns (x values) and rows (y values) for checking pixel precision.
  def draw_debug_grid
    72.step(1280, 72).each do |x|
      Gosu.draw_line(
        x, 0, Gosu::Color::BLACK,
        x, 720, Gosu::Color::BLACK
      )
    end
    72.step(720, 72).each do |y|
      Gosu.draw_line(
        0, y, Gosu::Color::BLACK,
        1280, y, Gosu::Color::BLACK
      )
    end
  end

  def hud_text(text, x:, y:)
    @hud_font.draw_text(text, x, y, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
  end

  def draw_choice(x:, y:, x_scale:, y_scale:)
    @choice_sprite.draw(x, y, ZOrder::UI_BACKDROP, x_scale, y_scale)
  end

  def action_for_coordinates(x, y)
    offset = 128
    y_static = 40

    if y.between?(y_static, y_static + offset)
      return choices[0] if x.between?(400, 400 + offset)
      return choices[1] if x.between?(576, 576 + offset)
      return choices[2] if x.between?(752, 752 + offset)
    end
  end
end
