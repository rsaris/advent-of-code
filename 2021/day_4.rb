require 'set'

require_relative 'lib/read_file'

class Board
  attr_reader(
    :all_numbers,
    :board,
    :called_numbers,
    :debug,
    :winner,
  )

  def initialize(board, debug: false)
    @debug = debug

    @board = board
    @all_numbers = board.reduce(Set.new) { |acc, row| acc.merge(row) }

    @called_numbers = Set.new
    @winner = false

    print_board(true)
    puts "DEBUG Found numbers #{all_numbers.join(', ')}" if debug
  end

  def call_number(number)
    @called_numbers.add(number)
    if all_numbers.include?(number)
      @winner ||= check_winner?(number)
    end

    @winner
  end

  def print_board(debug_only = false)
    return if debug_only && !debug

    board.each do |row|
      row_display =
        row.map do |n|
          if called_numbers.include?(n)
            '**'
          elsif n > 9
            n
          else
            " #{n}"
          end
        end.join(' ')
      puts "#{debug_only ? 'DEBUG ' : '' } #{row_display}"
    end
  end

  alias :winner? :winner

  private

  def check_winner?(number)
    board.each_with_index do |row, index|
      num_index = row.index(number)
      next if num_index.nil?

      if row.all? { |num| called_numbers.include?(num) } ||
          board.all? do |row2|
            called_numbers.include?(row2[num_index])
          end
        return true
      end
    end

    return false
  end
end

def parse_inputs(inputs, debug: false)
  numbers_to_call = inputs[0].split(',').map(&:to_i)

  cur_board = []
  boards =
    inputs[2..].reduce([]) do |acc, line|
      if line == ''
        acc << Board.new(cur_board, debug: debug)
        cur_board = []
      else
        cur_board << line.strip.split(/\s+/).map(&:to_i)
      end

      acc
    end

  if cur_board.length > 0
    boards << Board.new(cur_board, debug: debug)
  end

  [numbers_to_call, boards]
end

def do_part_1
  debug = false

  inputs = read_file('day_4.txt')
  numbers_to_call, boards = parse_inputs(inputs, debug: debug)

  winning_board = nil
  numbers_to_call.each do |number_to_call|
    puts "DEBUG Calling #{number_to_call}" if debug

    winning_board = boards.find { |board| board.call_number(number_to_call) }
    if winning_board
      puts "DEBUG Found a winner:" if debug

      winning_board.print_board(true)
      unmarked_numbers = winning_board.all_numbers - winning_board.called_numbers
      puts "DEBUG Found unmarked numbers #{unmarked_numbers.join(', ')}" if debug
      puts unmarked_numbers.sum * number_to_call
      return
    end
  end
end

puts 'Part 1'
do_part_1 # 45031
