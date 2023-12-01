require_relative './lib/read_file'

def do_part_1
  inputs = read_file('day_1.txt') do |line|
    cleaned_line = line.gsub(/[a-zA-Z]/, '')
    "#{cleaned_line[0]}#{cleaned_line[-1]}".to_i
  end

  puts inputs.sum
end

def do_part_2
  inputs = read_file('day_1.txt') do |line|
    matched_numbers =
      line.scan(/(?=([1-9]|one|two|three|four|five|six|seven|eight|nine))/).flatten.map do |match|
        if match.match(/[1-9]/)
          match.to_i
        elsif match == 'one'
          1
        elsif match == 'two'
          2
        elsif match == 'three'
          3
        elsif match == 'four'
          4
        elsif match == 'five'
          5
        elsif match == 'six'
          6
        elsif match == 'seven'
          7
        elsif match == 'eight'
          8
        elsif match == 'nine'
          9
        else
          raise "Found odd match #{match}"
        end
      end
    "#{matched_numbers[0]}#{matched_numbers[-1]}".to_i
  end

  puts inputs.sum
end

do_part_1 # 54159
do_part_2 # 53866
