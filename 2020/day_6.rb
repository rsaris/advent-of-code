require_relative 'lib/read_declaration_forms'

def do_part_1
  puts read_declaration_forms('day-6.txt').map(&:num_unique_responses).sum
end

def do_part_2
  puts read_declaration_forms('day-6.txt').map(&:num_exhaustive_responses).sum
end

do_part_1 # 6551
do_part_2 # 3358
