require_relative './lib/read_file'

require 'pry'

COMMAND_REGEX = /^(?<direction>[UDLR]) (?<steps>\d*)/

Point = Struct.new(:x, :y)

def update_point_for_command(point, command)
  command_match = command.match(COMMAND_REGEX)
  case command_match['direction']
  when 'U'
    point.y = point.y + command_match['steps'].to_i
  when 'D'
    point.y = point.y - command_match['steps'].to_i
  when 'R'
    point.x = point.x + command_match['steps'].to_i
  when 'L'
    point.x = point.x - command_match['steps'].to_i
  end

  point
end

def reconcile_point(head_point, next_point, tracking_hash = nil)
  x_delta = head_point.x - next_point.x
  y_delta = head_point.y - next_point.y

  if (x_delta.abs > 1 && y_delta.abs > 0) || (x_delta.abs > 0 && y_delta.abs > 1)
    next_point.x += x_delta / x_delta.abs
    next_point.y += y_delta / y_delta.abs
  elsif x_delta.abs > 1
    next_point.x += x_delta / x_delta.abs
  elsif y_delta.abs > 1
    next_point.y += y_delta / y_delta.abs
  end

  if tracking_hash
    tracking_hash[next_point.x] ||= {}
    tracking_hash[next_point.x][next_point.y] = true
  end
end

def reconcile_points(head_point, next_point, tracking_hash = nil)
  while (head_point.x - next_point.x).abs > 1 || (head_point.y - next_point.y).abs > 1
    reconcile_point(head_point, next_point, tracking_hash)
  end
end

def do_part_1
  head_point = Point.new(0, 0)
  tail_point = Point.new(0, 0)

  tail_positions = { 0 => { 0 => true } } # Set 0,0 to true

  lines = read_file('day_9.txt')
  lines.each do |line|
    update_point_for_command(head_point, line)
    reconcile_points(head_point, tail_point, tail_positions)
  end

  puts tail_positions.values.sum { |array| array.count }
end

def do_part_2
  points = (0..9).map { |i| Point.new(0, 0) }

  tail_positions = { 0 => { 0 => true } } # Set 0,0 to true

  lines = read_file('day_9.txt')
  lines.each do |line|
    update_point_for_command(points[0], line)
    while (points[0].x - points[1].x).abs > 1 || (points[0].y - points[1].y).abs > 1
      (1..8).each do |index|
        reconcile_point(points[index-1], points[index])
      end
      reconcile_point(points[8], points[9], tail_positions)
    end
  end

  puts tail_positions.values.sum { |array| array.count }
end

puts 'PART 1'
do_part_1 # 6354

puts 'PART 2'
do_part_2 # 2651
