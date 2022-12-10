require_relative './lib/read_file'

COMMAND_REGEX = /^(?<command>(noop)|(addx)) ?(?<param>.*)$/

def do_part_1
  lines = read_file('day_10.txt')
  register = 1
  line_index = 0
  tracked_value = 0

  adding = false

  (1..220).each do |cycle|
    if [20, 60, 100, 140, 180, 220].include?(cycle)
      tracked_value += register * cycle
    end

    command_match = lines[line_index].match(COMMAND_REGEX)

    if adding
      register += command_match['param'].to_i
      line_index += 1
      adding = false
    elsif command_match['command'] == 'noop'
      line_index += 1
    elsif command_match['command'] == 'addx'
      adding = true
    end
  end

  puts tracked_value
end

puts 'PART 1'
do_part_1 # 17180
