require_relative 'lib/read_inputs'

class SeatMap
  attr_reader :rows # Matrix where nil is floor, true is occupied, false is unoccupied

  def initialize(file_name)
    @rows =
      read_inputs(file_name).map do |row|
        row.split('').map { |c| c == 'L' ? false : nil }
      end
  end

  def stabilze(version = 1)
    known_maps = {}
    cur_rows = @rows

    while known_maps[print_map(cur_rows)].nil?
      known_maps[print_map(cur_rows)] = true
      cur_rows = step_map(cur_rows, version)
    end

    num_occupied(cur_rows)
  end

  def next_neighbor(rows, row, col, d_row, d_col, version)
    return if d_row < 0 && row <= 0
    return if d_row > 0 && row >= rows.size - 1
    return if d_col < 0 && col <= 0
    return if d_col > 0 && col >= rows[row].size - 1


    direct_neighbord = rows[row + d_row][col + d_col]

    if version == 1 || !direct_neighbord.nil?
      direct_neighbord
    else
      next_neighbor(rows, row + d_row, col + d_col, d_row, d_col, version)
    end
  end

  def num_occupied(rows)
    rows.map { |row| row.count { |c| c } }.sum
  end

  def num_neighbors(rows, row, col, version = 1)
    surrounding_seats = []

    surrounding_seats << next_neighbor(rows, row, col, -1, -1, version)
    surrounding_seats << next_neighbor(rows, row, col, -1, 0, version)
    surrounding_seats << next_neighbor(rows, row, col, -1, +1, version)

    surrounding_seats << next_neighbor(rows, row, col, 0, -1, version)
    surrounding_seats << next_neighbor(rows, row, col, 0, +1, version)

    surrounding_seats << next_neighbor(rows, row, col, +1, -1, version)
    surrounding_seats << next_neighbor(rows, row, col, +1, 0, version)
    surrounding_seats << next_neighbor(rows, row, col, +1, +1, version)

    surrounding_seats.count { |c| c }
  end

  def print_map(rows)
    rows.map { |row| row.map { |c| c ? '#' : (c.nil? ? '.' : 'L') }.join }.join("\n")
  end

  def step_map(rows, version = 1)
    next_map = []

    rows.each_with_index do |cells, row|
      next_map[row] = []

      cells.each_with_index do |cell, col|
        num_neighbors = num_neighbors(rows, row, col, version)

        next_map[row][col] =
          if cell.nil?
            nil
          elsif cell && num_neighbors >= (version == 1 ? 4 : 5)
            false
          elsif !cell && num_neighbors == 0
            true
          else
            cell
          end
      end
    end

    next_map
  end
end

def do_part_1
  puts SeatMap.new('day-11.txt').stabilze
end

def do_part_2
  puts SeatMap.new('day-11.txt').stabilze(2)
end

do_part_1 # 2204
do_part_2 # 1986
