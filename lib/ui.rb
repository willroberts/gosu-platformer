# frozen_string_literal: true

module UI
  def self.initialize
    @hud_font = Gosu::Font.new(20)
    @big_font = Gosu::Font.new(64)
    @health_frame = Gosu::Image.new('sprites/hud/health_frame.png', tileable: false)
    @health_bar = Gosu::Image.new('sprites/hud/health_bar.png', tileable: false)
    @window_sprite = Gosu::Image.new('sprites/hud/window.png', tileable: false)

    @enable_debug_grid = false
  end

  def self.draw(game_state)
    # Parse game state.
    stage = game_state.current_stage
    choices = game_state.choices
    input_locked = game_state.input_locked
    player_health = game_state.player_health
    tutorial_done = game_state.tutorial_done
    level_done = game_state.level_done

    # Display health bar.
    @health_frame.draw(10, 10, ZOrder::UI, 0.5, 0.5)
    @health_bar.draw(20, 20, ZOrder::UI, player_health * 0.1, 0.5)

    # Tutorial window.
    unless tutorial_done
      @window_sprite.draw(366, 266, ZOrder::UI_BACKDROP, 0.6, 0.6)
      @hud_font.draw('Welcome to Gosu Platformer!', 500, 300, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
      @hud_font.draw('Play each turn by choosing from three action cards.', 400, 360, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
      @hud_font.draw('Use movement and abilities to avoid taking damage.', 400, 390, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
      @hud_font.draw('Heal yourself by collecting potions.', 400, 420, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
      @hud_font.draw('Make it to the end of the level to win!', 400, 450, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
      @hud_font.draw('Click anywhere to continue.', 500, 510, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
    end

    # Card choices.
    if !input_locked
      if choices.length == 3
        @window_sprite.draw(400, 40, ZOrder::UI_BACKDROP, 0.1559, 0.2525)
        @hud_font.draw_text(choices[0].text, 400+44, 40+54, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
        @window_sprite.draw(576, 40, ZOrder::UI_BACKDROP, 0.1559, 0.2525)
        @hud_font.draw_text(choices[1].text, 576+44, 40+54, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
        @window_sprite.draw(752, 40, ZOrder::UI_BACKDROP, 0.1559, 0.2525)
        @hud_font.draw_text(choices[2].text, 752+44, 40+54, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
      else
        raise 'Invalid number of choices!'
      end
    end

    # Game over text.
    if level_done
      @window_sprite.draw(416, 266, ZOrder::UI_BACKDROP, 0.5, 0.25)
      @big_font.draw_text("You win!", 500, 300, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
    end

    # Level debug grid.
    draw_debug_grid if @enable_debug_grid
  end

  # Draws a grid of columns (x values) and rows (y values) for checking pixel precision.
  def self.draw_debug_grid
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
end
