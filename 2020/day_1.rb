require_relative 'lib/read_inputs'

def do_part_1(inputs)
  inputs.each_with_index do |x_value, x_index|
    inputs.each_with_index do |y_value, y_index|
      next if x_index == y_index

      if x_value + y_value == 2020
        puts x_value * y_value
        return
      end
    end
  end
end

def do_part_2(inputs)
  inputs.each_with_index do |x_value, x_index|
    inputs.each_with_index do |y_value, y_index|
      next if x_index == y_index
      next if x_value + y_value >= 2020

      inputs.each_with_index do |z_value, z_index|
        next if x_index == z_index
        next if y_index == z_index


        if x_value + y_value + z_value == 2020
          puts x_value * y_value * z_value
          return
        end
      end
    end
  end
end

inputs = read_inputs('day-1.txt', map_method: :to_i)

do_part_1(inputs) # 927684
do_part_2(inputs) # 292093004

