require_relative './lib/read_file'

PRIORITY = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'

def get_priority(letter)
  PRIORITY.index(letter) + 1
end

def split_rucksack(line)
  [line[0..line.length / 2 - 1], line[line.length / 2..]]
end

def do_part_1
  lines = read_file('day_3.txt')

  priorities = lines.map do |line|
    first_pack, second_pack = split_rucksack(line)
    if "#{first_pack}#{second_pack}" != line
      raise "Found bad split #{first_pack} and #{second_pack} from #{line}"
    end

    if first_pack.size != second_pack.size
      raise "Found uneven split #{first_pack} and #{second_pack} from #{line}"
    end

    common_letter = (first_pack.split('') & second_pack.split(''))[0]
    get_priority(common_letter)
  end

  puts priorities.sum
end

def do_part_2
  lines = read_file('day_3.txt')

  priorities = lines.each_slice(3).map do |group|
    common_letter = (group[0].split('') & group[1].split('') & group[2].split(''))[0]
    get_priority(common_letter)
  end

  puts priorities.sum
end


puts 'PART 1'
do_part_1 # 7674

puts 'PART 2'
do_part_2 # 2805
