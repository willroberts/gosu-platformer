# frozen_string_literal: true

module UI
  def self.initialize
    @hud_font = Gosu::Font.new(20)

    @cardback_color = Gosu::Color.argb(0xff_299adb)

    @enable_debug_grid = false
  end

  def self.draw(game_state)
    # Parse game state.
    stage = game_state.current_stage
    choices = game_state.choices

    # Top-left text UI.
    @hud_font.draw_text("Current stage: #{stage}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
    @hud_font.draw_text('Press ESC to quit', 10, 40, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)

    # Card choices.
    if choices.length == 3
      Gosu.draw_rect(400, 40, 128, 128, @cardback_color)
      @hud_font.draw_text(choices[0].text, 400+44, 40+4, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
      Gosu.draw_rect(576, 40, 128, 128, @cardback_color)
      @hud_font.draw_text(choices[1].text, 576+44, 40+4, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
      Gosu.draw_rect(752, 40, 128, 128, @cardback_color)
      @hud_font.draw_text(choices[2].text, 752+44, 40+4, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
    else
      raise 'Invalid number of choices!'
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
