# frozen_string_literal: true

module UI
  def self.initialize
    @font = Gosu::Font.new(20)
    @enable_debug_grid = false
    @choices = []
    @choices.push(WalkCard.new)
    @choices.push(JumpCard.new)
    @choices.push(RestCard.new)
  end

  def self.draw(stage)
    # Top-left text UI.
    @font.draw_text("Current stage: #{stage}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
    @font.draw_text('Press W to move forward', 10, 40, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
    @font.draw_text('Press SPACE to jump', 10, 70, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
    @font.draw_text('Press ESC to quit', 10, 100, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)

    # Card choices.
    if @choices.length == 3
      Gosu.draw_rect(400, 40, @choices[0].size, @choices[0].size, Gosu::Color::BLUE)
      Gosu.draw_rect(576, 40, @choices[0].size, @choices[0].size, Gosu::Color::BLUE)
      Gosu.draw_rect(752, 40, @choices[0].size, @choices[0].size, Gosu::Color::BLUE)
    else
      raise "Expected 3 card choices; got #{@choices.length}"
    end

    # Level debug grid.
    draw_debug_grid if @enable_debug_grid
  end

  def self.show_choices
    @choices.each do |c|
      c.visible = true
    end
  end

  def self.hide_choices
    @choices.each do |c|
      c.visible = false
    end
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
