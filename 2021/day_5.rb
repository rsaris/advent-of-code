require_relative 'lib/read_file'

class VentLine
  attr_reader(
    :x1,
    :y1,
    :x2,
    :y2,
    :skip_diagonal,
  )

  def initialize(x1, y1, x2, y2, skip_diagonal: false)
    @x1 = x1
    @y1 = y1
    @x2 = x2
    @y2 = y2

    @skip_diagonal = skip_diagonal
  end

  def points
    @points ||= begin
      x_slope = x2 - x1
      y_slope = y2 - y1

      if x_slope == 0
        range =
          if y1 < y2
            (y1..y2)
          else
            (y2..y1)
          end
        range.map { |y| { x: x1, y: y } }
      elsif y_slope == 0
        range =
          if x1 < x2
            (x1..x2)
          else
            (x2..x1)
          end
        range.map { |x| { x: x, y: y1 } }
      elsif !skip_diagonal
        x_range, y_range =
          if x1 < x2
            [
              (x1..x2),
              y1 < y2 ? (y1..y2).to_a : (y2..y1).to_a.reverse,
            ]
          else
            [
              (x2..x1),
              y2 < y1 ? (y2..y1).to_a : (y1..y2).to_a.reverse,
            ]
          end
        x_range.each_with_index.map { |x, i| { x: x, y: y_range[i] }}
      else
        []
      end
    end
  end

  def print_line
    puts "(#{x1}, #{y1}) -> (#{x2}, #{y2})"
    points.each { |point| puts "(#{point[:x]}, #{point[:y]})" }
  end
end

class VentMap
  attr_reader(
    :lines,
    :map,
    :max_row,
    :skip_diagonal,
  )

  def initialize(inputs, debug: false, skip_diagonal: false)
    @skip_diagonal = skip_diagonal

    @lines = parse_inputs(inputs)
    @map = build_map
    @max_row = @map.map { |row| row&.length.to_i }.max

    if debug
      @lines.each(&:print_line)
      print_map
    end
  end

  def num_points_above_threshold(threshold)
    map.sum do |row|
      if row
        row.count { |n| n && n >= threshold }
      else
        0
      end
    end
  end

  def print_map(debug_only = false)
    puts '-------------------------'
    map.each do |row|
      row_display =
        (0..(max_row - 1)).map do |index|
          (row || [])[index] || '.'
        end.join

      puts "#{debug_only ? 'DEBUG ' : ''} #{row_display}"
    end
    puts '-------------------------'
  end

  private

  def build_map
    map = []
    @lines.each do |line|
      line.points.each do |point|
        map[point[:y]] ||= []
        map[point[:y]][point[:x]] ||= 0
        map[point[:y]][point[:x]] += 1
      end
    end

    map
  end


  def parse_inputs(inputs)
    inputs.map do |input|
      match = input.match(/(?<x1>\d*),(?<y1>\d*) -> (?<x2>\d*),(?<y2>\d*)/)
      VentLine.new(
        match['x1'].to_i,
        match['y1'].to_i,
        match['x2'].to_i,
        match['y2'].to_i,
        skip_diagonal: @skip_diagonal
      )
    end
  end
end

def do_part_1
  inputs = read_file('day_5.txt')
  vent_map = VentMap.new(inputs, skip_diagonal: true)
  puts vent_map.num_points_above_threshold(2)
end


def do_part_2
  inputs = read_file('day_5.txt')
  vent_map = VentMap.new(inputs, debug: true)
  puts vent_map.num_points_above_threshold(2)
end

puts 'PART 1'
do_part_1 # 5167

puts 'PART 2'
do_part_2 # 17604
