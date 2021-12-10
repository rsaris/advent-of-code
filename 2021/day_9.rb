require 'pry'
require 'set'
require_relative 'lib/read_file'

def read_rows
  rows =
    read_file('day_9.txt') do |row|
      row.split('').map(&:to_i)
    end
end

def find_low_points(rows)
  low_points = []

  (0..rows.size - 1).each do |row_index|
    (0..rows[row_index].size - 1).each do |col_index|
      cur_value = rows[row_index][col_index]

      begin
        next if row_index > 0 && rows[row_index-1][col_index] <= cur_value
        next if row_index < rows.size - 1 && rows[row_index + 1][col_index] <= cur_value
        next if col_index > 0 && rows[row_index][col_index - 1] <= cur_value
        next if col_index < rows[row_index].size - 1 && rows[row_index][col_index + 1] <= cur_value
      rescue
        binding.pry
      end

      low_points << [row_index, col_index]
    end
  end

  low_points
end

def do_part_1
  rows = read_rows
  low_points = find_low_points(rows)

  puts low_points.map { |low_point| rows[low_point.first][low_point.last] + 1 }.sum
end

def do_part_2
  rows = read_rows
  low_points = find_low_points(rows)

  basin_sizes =
    low_points.map do |low_point|
      processed_points = Set.new

      to_process = Set.new
      to_process.add(low_point)

      while to_process.any?
        cur_point = to_process.first
        to_process.delete(cur_point)
        cur_row, cur_col = cur_point
        processed_points.add(cur_point)

        if cur_row > 0
          left_point = [cur_row - 1, cur_col]
          if rows[left_point.first][left_point.last] != 9 && !processed_points.include?(left_point)
            to_process.add(left_point)
          end
        end
        if cur_col > 0
          up_point = [cur_row, cur_col - 1]
          if rows[up_point.first][up_point.last] != 9 && !processed_points.include?(up_point)
            to_process.add([cur_row, cur_col - 1])
          end
        end
        if cur_row < rows.size - 1
          right_point = [cur_row + 1, cur_col]
          if rows[right_point.first][right_point.last] != 9 && !processed_points.include?(right_point)
            to_process.add([cur_row + 1, cur_col])
          end
        end
        if cur_col < rows[cur_row].size - 1
          down_point = [cur_row, cur_col + 1]
          if rows[down_point.first][down_point.last] != 9 && !processed_points.include?(down_point)
            to_process.add([cur_row, cur_col + 1])
          end
        end
      end

      processed_points.size
    end

  puts basin_sizes.sort[-3..].inject(:*)
end

puts 'PART 1'
do_part_1 # 496

puts 'PART 2'
do_part_2 # 902880
