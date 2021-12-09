require 'pry'

require_relative 'lib/read_file'

def build_tally_map(digits)
  digits.flat_map(&:scrambled_signals).tally.reduce({}) do |acc, tuple|
    acc[tuple.last] ||= []
    acc[tuple.last] << tuple.first
    acc
  end
end

class Digit
  attr_reader :scrambled_signals

  def initialize(scrambled_signals)
    @scrambled_signals = scrambled_signals.split('').sort
  end

  def sorted_signal
    scrambled_signals.join('')
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
    current_digits.count { |digit| [2, 3, 4, 7].include?(digit.signal_length) }
  end

  def solved_value
    # puts "Looking at #{seed_digits.map(&:sorted_signal).join(' ')} | #{current_digits.map(&:sorted_signal).join(' ')}"

    signal_map = {}
    digit_map = []

    digit_map[1] = seed_digits.find { |digit| digit.signal_length == 2 }
    digit_map[4] = seed_digits.find { |digit| digit.signal_length == 4 }
    digit_map[7] = seed_digits.find { |digit| digit.signal_length == 3 }
    digit_map[8] = seed_digits.find { |digit| digit.signal_length == 7 }

    five_piece_digits = seed_digits.select { |digit| digit.signal_length == 5 }

    six_piece_digits = seed_digits.select { |digit| digit.signal_length == 6 }
    six_piece_tally = build_tally_map(six_piece_digits)

    signal_map['a'] = (digit_map[7].scrambled_signals - digit_map[1].scrambled_signals).first
    signal_map['c'] = six_piece_tally[2].find { |signal| digit_map[1].scrambled_signals.include?(signal) }
    signal_map['f'] = (digit_map[1].scrambled_signals - [signal_map['c']]).first

    # Knowing C and F we can figure out all the 5 piece digits
    five_piece_digits.each do |digit|
      if digit.scrambled_signals.include?(signal_map['c'])
        if digit.scrambled_signals.include?(signal_map['f'])
          digit_map[3] = digit
        else
          digit_map[2] = digit
        end
      else
        digit_map[5] = digit
      end
    end

    # And 6 is the six piecer missing c
    digit_map[6] = six_piece_digits.find { |digit| !digit.scrambled_signals.include?(signal_map['c']) }

    # Now to find 0 and 9!
    nine_or_zero = six_piece_digits - [digit_map[6]]
    g_or_d = build_tally_map([digit_map[2], digit_map[5]])[2].select { |signal| signal_map['a'] != signal }
    d_or_e = build_tally_map(nine_or_zero)[1]
    signal_map['d'] = (g_or_d & d_or_e).first

    nine_or_zero.each do |digit|
      if digit.scrambled_signals.include?(signal_map['d'])
        digit_map[9] = digit
      else
        digit_map[0] = digit
      end
    end

    signal_to_number_map =
      digit_map.each_with_index.reduce({}) do |acc, tuple|
        acc[tuple.first.sorted_signal] = tuple.last
        acc
      end

    current_digits.map { |digit| signal_to_number_map[digit.sorted_signal] }.join('').to_i
  end
end

def read_puzzle_inputs
  read_file('day_8.txt') do |line|
    seeds, current = line.split('|').map(&:strip)
    PuzzleInput.new(
      seeds.split(' ').map { |d| Digit.new(d.strip) },
      current.split(' ').map { |d| Digit.new(d.strip) },
    )
  end
end


def do_part_1
  inputs = read_puzzle_inputs

  puts inputs.map(&:num_simple_digits_in_current).sum
end

def do_part_2
  inputs = read_puzzle_inputs

  puts inputs.map(&:solved_value).sum
end


puts 'PART 1'
do_part_1 # 381

puts 'PART 2'
do_part_2 # 1023686
