require_relative 'lib/read_file'

def read_depths
  read_file('day_1.txt') { |line| line.to_i }
end

def build_depth_groups(depths, size = 3)
  depths[..-size].each_with_index.map { |d, i| depths[i] + depths[i+1] + depths[i+2] }
end

def count_increases(depths)
  depths[1..].each_with_index.count { |d, i| d > depths[i] }
end

def do_part_1
  puts count_increases(read_depths)
end

def do_part_2
  puts count_increases(build_depth_groups(read_depths))
end

puts 'PART 1'
do_part_1 # 1316

puts 'PART 2'
do_part_2 # 1344
