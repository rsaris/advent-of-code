require_relative 'lib/adapter_set'

def do_part_1
  adapter_set = AdapterSet.new('day-10.txt')
  diff_map = adapter_set.diff_map(adapter_set.adapters)

  puts diff_map[:num_1s] * diff_map[:num_3s]
end

def do_part_2
  puts AdapterSet.new('day-10.txt').num_chains
end

do_part_1 # 2482
do_part_2 # 96717311574016
