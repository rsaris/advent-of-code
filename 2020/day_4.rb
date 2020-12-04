require_relative 'lib/read_passports'

def do_part_1
  puts read_passports('day-4.txt').count(&:valid?)
end

do_part_1 # 192
