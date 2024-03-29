require 'pry'
require_relative 'lib/read_file'

def do_it(num_steps)
  debug = true
  template = nil
  insertion_map = {}

  read_file('day_14.txt') do |line|
    if template.nil?
      template = line
      next
    elsif line == ''
      next
    end

    key, value = line.split(' -> ')
    insertion_map[key] = value
  end

  cur_state = template.split('')
  num_steps.times do |i|
    puts "Running step #{i}" if debug
    next_state = []

    cur_state.each_with_index do |val, index|
      next_state << insertion_map[cur_state[index - 1] + val] unless index.zero?
      next_state << val
    end

    cur_state = next_state
  end

  tally = cur_state.tally
  inverted_tally = tally.invert
  puts inverted_tally.keys.max - inverted_tally.keys.min
end

def do_part_1
  do_it(10)
end

def do_part_2
  do_it(40)
end

puts 'PART 1'
do_part_1 # 2027

puts 'PART 2'
do_part_2 #
