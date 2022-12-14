require_relative './lib/read_file'

require 'pry'

class Point
  attr_accessor :shortest_path_point, :path_size

  attr_reader :first_coord, :second_coord, :height

  def initialize(first_coord, second_coord, height)
    @first_coord = first_coord
    @second_coord = second_coord
    @height = height
  end

  def display_string
    "(#{first_coord}, #{second_coord})"
  end
end


class Map
  attr_reader :start_point, :end_point, :points

  def initialize(file)
    @points = read_file(file).each_with_index.map do |line, first_coord|
      line.split('').each_with_index.map do |letter, second_coord|
        if letter == 'S'
          @start_point = Point.new(first_coord, second_coord, 0)
        elsif letter == 'E'
          @end_point = Point.new(first_coord, second_coord, 25)
        else
          Point.new(first_coord, second_coord, letter.ord - 97)
        end
      end
    end
  end

  def build_paths
    @end_point.path_size = 0
    build_paths_to_point(@end_point)
  end

  def build_paths_to_point(point)
    if point.first_coord > 0
      build_paths_between_points(point, @points[point.first_coord - 1][point.second_coord])
    end
    if point.first_coord < @points.size - 1
      build_paths_between_points(point, @points[point.first_coord + 1][point.second_coord])
    end
    if point.second_coord > 0
      build_paths_between_points(point, @points[point.first_coord][point.second_coord - 1])
    end
    if point.second_coord < @points[0].size - 1
      build_paths_between_points(point, @points[point.first_coord][point.second_coord + 1])
    end
  end

  def build_paths_between_points(first_point, second_point)
    return if first_point.height > second_point.height && first_point.height - second_point.height > 1
    return if second_point.path_size && second_point.path_size <= first_point.path_size + 1

    second_point.path_size = first_point.path_size + 1
    second_point.shortest_path_point = first_point

    if second_point != @start_point
      build_paths_to_point(second_point)
    end
  end
end

def do_part_1(map)
  puts map.start_point.path_size
end

def do_part_2(map)
  shortest_path = nil
  map.points.each do |row|
    row.each do |point|
      if point.height == 0 && point.path_size && (shortest_path.nil? || shortest_path >= point.path_size)
        shortest_path = point.path_size
      end
    end
  end
  puts shortest_path
end

map = Map.new('day_12.txt')
map.build_paths
puts 'Done building map'

puts 'PART 1'
do_part_1(map)# 490

puts 'PART 2'
do_part_2(map) # 488
