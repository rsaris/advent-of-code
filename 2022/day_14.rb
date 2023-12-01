require_relative './lib/read_file'

ROCK = 1
SAND = 2

class Map
  def initialize
    @map = {}
    @max_x = 500
    @min_x = 500
    @max_y = 0
    @min_y = 0

    lines = read_file('day_14.txt')

    lines.each do |line|
      points = line.split('->').map(&:strip).map { |point| point.split(',').map(&:to_i) }
      prev_point = nil

      points.each do |point|
        @max_x = [point[0], @max_x].max
        @min_x = [point[0], @min_x].min
        @max_y = [point[1], @max_y].max
        @min_y = [point[1], @min_y].min

        if prev_point
          x_range = prev_point[0] < point[0] ? (prev_point[0]..point[0]) : (point[0]..prev_point[0])
          y_range = prev_point[1] < point[1] ? (prev_point[1]..point[1]) : (point[1]..prev_point[1])

          x_range.each do |new_x|
            y_range.each do |new_y|
              @map[new_x] ||= {}
              @map[new_x][new_y] = ROCK
            end
          end
        end

        prev_point = point
      end
    end
  end

  def print
    puts '    ' + (@min_x..@max_x).map { |x| '%02d' % (x - @min_x)  }.map(&:to_s).join('')

    (@min_y..@max_y).each do |cur_y|
      output = "#{'%03d' % cur_y} "
      (@min_x..@max_x).each do |cur_x|
        output +=
         case @map.dig(cur_x, cur_y)
         when ROCK
          '##'
         when SAND
          'oo'
         else
          '..'
         end
      end
      puts output
    end
  end
end

def do_part_1
  map = Map.new
  map.print
end

puts 'PART 1'
do_part_1
