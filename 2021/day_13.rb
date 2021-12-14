require 'pry'
require_relative 'lib/read_file'

class Paper
  def initialize
    @grid = []
    @max_x = 0
    @max_y = 0
  end

  def add_point(x, y)
    @grid[y] ||= []
    @grid[y][x] = 1
    @max_x = [@max_x, x].max
    @max_y = [@max_y, y].max
  end

  def print
    puts num_points

    string = (0..@max_y).to_a.map do |y|
      (0..@max_x).to_a.map { |x| (@grid[y] || [])[x] ? '#' : '.' }.join('')
    end.join("\n")

    puts string
  end

  def num_points
    (0..@max_y).sum do |y|
      (0..@max_x).sum do |x|
        (@grid[y] || [])[x] ? 1 : 0
      end
    end
  end

  def fold(direction, coordinate)
    if direction == 'x'
      (coordinate + 1..@max_x).each_with_index do |x, index|
        (0..@max_y).each do |y|
          if (@grid[y] || [])[x]
            @grid[y][x] = nil
            @grid[y][coordinate - index - 1] = 1
          end
        end
      end

      @max_x = coordinate
    else
      (coordinate + 1..@max_y).each_with_index do |y, index|
        (0..@max_x).each do |x|
          if (@grid[y] || [])[x]
            @grid[y][x] = nil
            @grid[coordinate - index - 1] ||= []
            @grid[coordinate - index - 1][x] = 1
          end
        end
      end

      @max_y = coordinate
    end
  end
end

def do_part_1
  paper = Paper.new
  instructions = []

  read_file('day_13.txt') do |line|
    x, y = line.split(',')
    if y
      paper.add_point(x.to_i, y.to_i)
    elsif line != ''
      instructions << x.gsub('fold along ', '').split('=')
    end
  end

  paper.print

  puts "---------------------\n\n"

  instructions.each do |instruction|
    puts "Handling instruction #{instruction[0]} = #{instruction[1]}"
    paper.fold(instruction[0], instruction[1].to_i)
    paper.print
  end

  # puts print_paper(grid, max_x, max_y)
end

puts 'PART 1'
do_part_1 # 751

# PGHRKLKL
