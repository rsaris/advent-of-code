require_relative 'lib/read_file'

def calculate_rates(inputs)
  num_inputs = inputs.size

  bit_counts = []
  inputs.each do |input|
    input.split('').each_with_index do |bit, pos|
      bit_counts[pos] ||= 0
      if bit == '1'
        bit_counts[pos] += 1
      end
    end
  end

  gamma = ''
  epsilon = ''

  bit_counts.each do |count|
    if count > (num_inputs / 2.0)
      gamma += '1'
      epsilon += '0'
    else
      gamma += '0'
      epsilon += '1'
    end
  end

  [gamma, epsilon]
end

def do_part_1
  inputs = read_file('day_3.txt')
  gamma, epsilon = calculate_rates(inputs)
  puts gamma.to_i(2) * epsilon.to_i(2)
end

puts 'PART 1'
do_part_1 # 3429254
