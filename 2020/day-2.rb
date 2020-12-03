require_relative 'lib/read_passwords'

def do_part_1
  puts read_passwords('day-2.txt').count(&:min_max_valid?)
end

def do_part_2
  puts read_passwords('day-2.txt').count(&:positions_valid?)
end

do_part_1 # 519
do_part_2 # 708