require 'set'

require_relative 'read_inputs'

class XmasCypher
  attr_reader :numbers, :preamble_size

  def initialize(file_name, preamble_size: 25)
    @numbers = read_inputs(file_name).map(&:to_i)
    @preamble_size = preamble_size
  end

  def find_invalid_number
    numbers[preamble_size..-1].each_with_index do |number, index|
      return number unless valid_number?(number, index + preamble_size)
    end

    raise 'Did not find an invalid number'
  end

  def find_weakness
    target_number = find_invalid_number

    numbers.each_with_index do |number, starting_index|
      cur_index = starting_index + 1
      while (sum = numbers[starting_index..cur_index].sum) < target_number
        cur_index += 1
      end

      if sum == target_number # If we hit the target, return the min and max in the current range
        return numbers[starting_index..cur_index].max + numbers[starting_index..cur_index].min
      end
    end
  end

  private

  def options_map
    @options_map ||=
      numbers.each_with_index.map do |number, index|
        numbers[(index + 1)..(index + preamble_size)].reduce(Set.new) do |acc, other_number|
          next if number == other_number
          acc.add(number + other_number)
        end
      end
  end

  def valid_number?(number, index)
    options_map[(index-preamble_size)..(index-1)].each do |option|
      return true if option.include?(number)
    end

    return false
  end
end
