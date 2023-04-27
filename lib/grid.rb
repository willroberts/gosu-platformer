# Grid keeps track of the contents of each level.
class Grid
  def initialize(cols, rows)
    @cells = []
    (0..cols).each do |x|
      @cells[x] = []
      (0..rows).each do |y|
        @cells[x][y] = Cell.new
      end
    end
  end
end

class Cell
  def initialize
    @platform = false
    @enemy = nil
    @potion = nil
  end
end
