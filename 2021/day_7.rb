require_relative 'lib/read_file'

def do_part_1
  debug = false

  inputs = read_file('day_7.txt')
  initial_position_map = inputs[0].split(',').map(&:to_i).reduce(Hash.new(0)) { |acc, pos| acc[pos] += 1; acc }
  puts "Found unique positions #{initial_position_map.keys.size}" if debug

  min_position = initial_position_map.keys.min
  max_position = initial_position_map.keys.max
  puts "Crabs are between #{min_position} and #{max_position}" if debug

  fuel_costs = {}
  (min_position..max_position).each do |position|
    puts "Testing position #{position}" if debug
    fuel_costs[position] =
      initial_position_map.map do |pos, num|
        (pos - position).abs * num
      end.sum
  end

  puts fuel_costs.min_by { |k, v| v }.last
end

puts 'PART 1'
do_part_1 # 337488
