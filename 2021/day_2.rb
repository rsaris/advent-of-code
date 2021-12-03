require_relative 'lib/read_file'
require_relative 'lib/submarine'

def do_part_1
  instructions = read_file('day_2.txt')
  submarine = Submarine.new
  submarine.follow_simple_instructions(instructions)
  puts submarine.x * submarine.y
end

def do_part_2
  instructions = read_file('day_2.txt')
  submarine = Submarine.new
  submarine.follow_aim_instructions(instructions)
  puts submarine.x * submarine.y
end

puts 'PART 1'
do_part_1 # 1962940

puts 'PART 2'
do_part_2
