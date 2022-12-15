require_relative './lib/read_file'

require 'pry'

class RightOrderError < StandardError; end
class WrongOrderError < StandardError; end

def compare_objects(left, right)
  if left.is_a?(Array) || right.is_a?(Array)
    compare_lists(Array(left), Array(right))
  elsif left < right
    raise RightOrderError
  elsif right < left
    raise WrongOrderError
  end
end

def compare_lists(left, right)
  (0...[left.size, right.size].max).each do |index|
    raise RightOrderError if left[index].nil? # Left list ran out of items
    raise WrongOrderError if right[index].nil? # Right list ran out of items

    compare_objects(left[index], right[index])
  end
end

def run_comparison(left, right)
  compare_lists(left, right)
  raise 'Compared lists without an exception...'
rescue RightOrderError
  return true
rescue WrongOrderError
  return false
end

Packet = Struct.new(:index, :first, :second) do
  attr_reader :valid

  def run
    @valid = run_comparison(first, second)
  end
end

def do_part_1
  lines = read_file('day_13.txt')
  packets = (0..(lines.size / 3)).map do |index|
    Packet.new(
      index + 1,
      eval(lines[index * 3]),
      eval(lines[index * 3 + 1]),
    )
  end

  puts packets.each(&:run).select(&:valid).map(&:index).sum
end

def do_part_2
  lines = read_file('day_13.txt')
  packets = lines.select { |line| line != '' }.map { |line| eval(line) }
  packets << [[2]]
  packets << [[6]]

  sorted_packets = packets.sort { |a, b| run_comparison(a, b) ? -1 : 1 }
  puts (sorted_packets.index([[2]]) + 1) * (sorted_packets.index([[6]]) + 1)
end

puts 'PART 1'
do_part_1 # 6484

puts 'PART 2'
do_part_2 # 19305
