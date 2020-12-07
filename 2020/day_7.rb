require_relative 'lib/read_bag_rules'

def do_part_1
  puts read_bag_rules('day-7.txt').available_parent_bags('shiny gold')
end

def do_part_2
  puts read_bag_rules('day-7.txt').required_bags('shiny gold') - 1
end

do_part_1 # 229
do_part_2 # 6683
