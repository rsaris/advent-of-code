require_relative 'lib/diagnostics'
require_relative 'lib/read_file'

def do_part_1
  inputs = read_file('day_3.txt')
  gamma, epsilon = Diagnostics.new(inputs).calculate_rates
  puts gamma.to_i(2) * epsilon.to_i(2)
end

def do_part_2
  inputs = read_file('day_3.txt')
  oxygen, carbon_dioxide = Diagnostics.new(inputs).calculate_ratings
  puts oxygen.to_i(2) * carbon_dioxide.to_i(2)
end

puts 'PART 1'
do_part_1 # 3429254

puts 'PART 2'
do_part_2 # 5410338
