require 'pry'
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


puts 'PART 1'
do_part_1 # 496
