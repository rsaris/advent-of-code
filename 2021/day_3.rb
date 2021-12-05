require_relative 'lib/diagnostics'
require_relative 'lib/read_file'

def do_part_1
  inputs = read_file('day_3.txt')
  gamma, epsilon = Diagnostics.new(inputs).calculate_rates
  puts gamma.to_i(2) * epsilon.to_i(2)
end

puts 'PART 1'
do_part_1 # 3429254
