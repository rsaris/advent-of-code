require_relative './lib/read_file'

require 'pry'

COMMAND_REGEX = /^(?<direction>[UDLR]) (?<steps>\d*)/

Point = Struct.new(:x, :y)

def do_part_1
  head_point = Point.new(0, 0)
  tail_point = Point.new(0, 0)

  tail_positions = { 0 => { 0 => true } } # Set 0,0 to true

  lines = read_file('day_9.txt')
  lines.each do |line|
    line_match = line.match(COMMAND_REGEX)
    case line_match['direction']
    when 'U'
      head_point.y = head_point.y + line_match['steps'].to_i
    when 'D'
      head_point.y = head_point.y - line_match['steps'].to_i
    when 'R'
      head_point.x = head_point.x + line_match['steps'].to_i
    when 'L'
      head_point.x = head_point.x - line_match['steps'].to_i
    end

    x_delta = head_point.x - tail_point.x
    y_delta = head_point.y - tail_point.y

    while x_delta.abs > 1 || y_delta.abs > 1
      if (x_delta.abs > 1 && y_delta.abs > 0) || (x_delta.abs > 0 && y_delta.abs > 1)
        tail_point.x += x_delta / x_delta.abs
        tail_point.y += y_delta / y_delta.abs
      elsif x_delta.abs > 1
        tail_point.x += x_delta / x_delta.abs
      elsif y_delta.abs > 1
        tail_point.y += y_delta / y_delta.abs
      else
        binding.pry
        raise "Unexpected deltas found #{x_delta} #{y_delta} on line #{line}"
      end

      tail_positions[tail_point.x] ||= {}
      tail_positions[tail_point.x][tail_point.y] = true
      x_delta = head_point.x - tail_point.x
      y_delta = head_point.y - tail_point.y
    end
  end

  puts tail_positions.values.sum { |array| array.count }
end

puts 'PART 1'
do_part_1 # 6354
