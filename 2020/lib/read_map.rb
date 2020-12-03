require_relative 'read_inputs'

class Map
  attr_reader :coordinates

  def initialize(rows)
    @coordinates = rows.map do |row|
      row.split('').map! { |i| i == '#' }
    end
  end

  def num_trees(slope_x, slope_y)
    count = cur_x = cur_y = 0
    while cur_y < num_rows
      count += 1 if tree?(cur_x, cur_y)
      cur_x += slope_x
      cur_y += slope_y
    end
    count
  end

  private

  def num_rows
    @coordinates.size
  end

  def tree?(x, y)
    row = @coordinates[y]
    x = x - row.size while x >= row.size

    row[x]
  end
end

def read_map(file_name)
  Map.new(read_inputs(file_name))
end
