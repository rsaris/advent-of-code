require_relative './lib/read_file'

MOVE_REGEX = /move (?<num>\d*) from (?<from_stack>\d*) to (?<to_stack>\d*)/

def debug_stacks(stacks)
  puts '-----'
  stacks.each_with_index { |stack, index| puts "#{index + 1}: #{stack.join(',')}" }
  puts '-----'
end

def split_file
  stacks = []
  moves = []

  lines = read_file('day_5.txt')
  lines.each do |line|
    line.strip == '' and next
    line[1] == '1' and next

    if line.match?(MOVE_REGEX)
      moves << line
    else
      stacks << line
    end
  end

  [stacks, moves]
end


def build_stacks(stack_lines)
  stacks = []
  first_line = stack_lines.first
  num_stacks = (first_line.length + 1) / 4

  stack_lines.each do |line|
    (0...num_stacks).each do |stack|
      stacks[stack] ||= []
      if (cur_char = line[stack * 4 + 1]) != ' '
        stacks[stack].push(cur_char)
      end
    end
  end

  stacks
end

def do_moves!(stacks, move_lines, deluxe: false)
  debug_stacks(stacks)
  move_lines.each do |line|
    match = line.match(MOVE_REGEX)
    from_stack_index = match['from_stack'].to_i - 1
    to_stack_index = match['to_stack'].to_i - 1

    moved_crates =
      (0...match['num'].to_i).map do |i|
        stacks[from_stack_index].shift
      end
    moved_crates.reverse! if deluxe
    moved_crates.each { |crate| stacks[to_stack_index].unshift(crate) }
  end
end

def do_part_1
  stack_lines, move_lines = split_file
  stacks = build_stacks(stack_lines)
  do_moves!(stacks, move_lines)

  puts stacks.map(&:first).join
end

def do_part_2
  stack_lines, move_lines = split_file
  stacks = build_stacks(stack_lines)
  do_moves!(stacks, move_lines, deluxe: true)

  puts stacks.map(&:first).join
end

puts 'PART 1'
do_part_1 # MQTPGLLDN

puts 'PART 2'
do_part_2 # LVZPSTTCZ
