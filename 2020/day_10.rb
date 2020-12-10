require_relative 'lib/adapter_set'

def do_part_1
  adapter_set = AdapterSet.new('day-10.txt')
  diff_map = adapter_set.diff_map(adapter_set.longest_chain)

  puts diff_map[:num_1s] * diff_map[:num_3s]
end

do_part_1 # 2482
