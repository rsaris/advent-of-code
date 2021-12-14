require 'pry'
require_relative 'lib/read_file'

def print_paper(grid, max_x, max_y)
  (0..max_y).to_a.map do |row_index|
    (0..max_x).to_a.map { |col_index| (grid[row_index] || [])[col_index] ? '#' : '.' }.join('')
  end.join("\n")
end

def fold(grid, direction, coordinate, max_x, max_y)
  if direction == 'x'
    (coordinate + 1..max_x).each_with_index do |x, index|
      (0..max_y).each do |y|
        if (grid[y] || [])[x]
          grid[y][x] = nil
          grid[y][coordinate - index - 1] = 1
        end
      end
    end
  else
    (coordinate + 1..max_y).each_with_index do |y, index|
      (0..max_x).each do |x|
        if (grid[y] || [])[x]
          grid[y][x] = nil
          grid[coordinate - index - 1] ||= []
          grid[coordinate - index - 1][x] = 1
        end
      end
    end
  end
end

def count_points(grid, max_x, max_y)
  (0..max_y).sum do |y|
    (0..max_x).sum do |x|
      (grid[y] || [])[x] ? 1 : 0
    end
  end
end


def do_part_1
  grid = []
  instructions = []
  max_x = 0
  max_y = 0

  read_file('day_13.txt') do |line|
    x, y = line.split(',')
    if y
      x_int = x.to_i
      y_int = y.to_i

      grid[y_int] ||= []
      grid[y_int][x_int] = 1

      max_x = [max_x, x_int].max
      max_y = [max_y, y_int].max
    elsif line != ''
      instructions << x.gsub('fold along ', '').split('=')
    end
  end

  puts count_points(grid, max_x, max_y)
  # puts print_paper(grid, max_x, max_y)

  puts "\n\n---------------------\n\n"

  instructions.each do |instruction|
    puts "Handling instruction #{instruction[0]} = #{instruction[1]}"
    fold(grid, instruction[0], instruction[1].to_i, max_x, max_y)
    puts count_points(grid, max_x, max_y)
    # puts print_paper(grid, max_x, max_y)
  end

  # puts print_paper(grid, max_x, max_y)
end

puts 'PART 1'
do_part_1 # 751
