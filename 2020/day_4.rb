require_relative 'lib/read_passports'

def do_part_1
  puts read_passports('day-4.txt').count(&:presence_valid?)
end

def do_part_2
  puts read_passports('day-4.txt').count(&:format_valid?)
end

do_part_1 # 192
do_part_2 # 101
