require_relative 'lib/xmas_cypher'


def do_part_1(test = false)
  cypher =
    if test
      XmasCypher.new('day-9.txt.sample', preamble_size: 5)
    else
      XmasCypher.new('day-9.txt')
    end
  puts cypher.find_invalid_number
end

def do_part_2
  puts XmasCypher.new('day-9.txt').find_weakness
end

do_part_1 # 1309761972
do_part_2
