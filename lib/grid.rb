# Grid keeps track of the contents of each level.
class Grid
  attr_reader :cells

  def initialize(cols, rows)
    @cells = []
    (0..cols).each do |x|
      @cells[x] = []
      (0..rows).each do |y|
        @cells[x][y] = Cell.new
      end
    end
  end

  def add_platforms(*coords)
    coords.each do |x, y|
      @cells[x][y].platform = true
    end
  end

  def add_enemies(*coords)
    coords.each do |x, y|
      @cells[x][y].enemy = true
    end
  end

  def add_potions(*coords)
    coords.each do |x, y|
      @cells[x][y].potion = true
    end
  end
end

class Cell
  attr_accessor :platform, :enemy, :potion

  def initialize
    @platform = false
    @enemy = false
    @potion = false
  end
end
