def read_depths(file_name)
  File.open("./inputs/#{file_name}").read.split("\n").map(&:to_i)
end

def do_part_1
  depths = read_depths('day_1.txt')
  puts depths[1..].each_with_index.count { |d, i| d > depths[i] }
end

puts 'PART 1'
do_part_1 # 1316
