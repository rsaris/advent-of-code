require_relative 'lib/read_map'

def do_part_1
  puts read_map('day-3.txt').num_trees(3, 1)
end

def do_part_2
  map = read_map('day-3.txt')

  puts (
    map.num_trees(1, 1) *
    map.num_trees(3, 1) *
    map.num_trees(5, 1) *
    map.num_trees(7, 1) *
    map.num_trees(1, 2)
  )
end

do_part_1 # 205
do_part_2 # 3952146825
