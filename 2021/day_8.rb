require_relative 'lib/read_file'

class Digit
  attr_reader :scrambled_signals

  def initialize(scrambled_signals)
    @scrambled_signals = scrambled_signals
  end

  def signal_length
    scrambled_signals.length
  end
end

class PuzzleInput
  attr_reader :seed_digits, :current_digits

  def initialize(seed_digits, current_digits)
    @seed_digits = seed_digits
    @current_digits = current_digits
  end

  def num_simple_digits_in_current
    @current_digits.count { |digit| [2, 3, 4, 7].include?(digit.signal_length) }
  end
end


def do_part_1
  inputs = read_file('day_8.txt') do |line|
    seeds, current = line.split('|').map(&:strip)
    PuzzleInput.new(
      seeds.split(' ').map { |d| Digit.new(d.strip) },
      current.split(' ').map { |d| Digit.new(d.strip) },
    )
  end

  puts inputs.map(&:num_simple_digits_in_current).sum
end


puts 'PART 1'
do_part_1 # 381
