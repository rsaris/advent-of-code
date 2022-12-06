require_relative './lib/read_file'

MARKER_SIZE = 4
MESSAGE_SIZE = 14

def find_first_window(input, window_size)
  cur_index = 0

  while cur_index < input.length - window_size
    dup_window = input[cur_index..(cur_index + window_size - 1)]
    if dup_window.split('').uniq.size != window_size
      # puts "Pushing forward with #{dup_window}"
      cur_index = cur_index + 1
    else
      # puts "Returning with #{dup_window}"
      return cur_index
    end
  end

  raise 'Reached end of string without finding a marker'
end

def do_part_1
  input = read_file('day_6.txt').first
  puts find_first_window(input, MARKER_SIZE) + MARKER_SIZE
end

def do_part_2
  input = read_file('day_6.txt').first
  puts "Found input #{input}"
  puts find_first_window(input, MESSAGE_SIZE) + MESSAGE_SIZE
end

puts 'PART 1'
do_part_1 # 1544

puts 'PART 2'
do_part_2 # 2145
