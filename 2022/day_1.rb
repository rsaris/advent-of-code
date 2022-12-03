require_relative './lib/read_file'


def do_part_1
  lines = read_file('day_1.txt')

  most_cals = 0
  current_cals = 0
  lines.each do |line|
    if line == ''
      if current_cals > most_cals
        most_cals = current_cals
      end
      current_cals = 0
    else
      current_cals += line.to_i
    end
  end

  if current_cals > most_cals
    most_cals = current_cals
  end

  puts most_cals
end

def do_part_2
  lines = read_file('day_1.txt')
  totals = []
  cur_cals = 0
  lines.each do |line|
    if line == ''
      totals << cur_cals
      cur_cals = 0
    else
      cur_cals += line.to_i
    end
  end
  totals << cur_cals

  puts totals.sort[-3..].sum
end

puts 'PART 1'
do_part_1 # 71300

puts 'PART 2'
do_part_2 # 209691
