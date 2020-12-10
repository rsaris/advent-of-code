require_relative 'read_inputs'

class AdapterSet
  attr_reader :adapters

  def initialize(file_name)
    @adapters = read_inputs('day-10.txt', map_method: :to_i).sort!
  end

  def longest_chain
    @adapters
  end

  def diff_map(chain)
    (0..chain.length-1).reduce(num_1s: 0, num_2s: 0, num_3s: 1) do |acc, index|
      diff =
        if index.zero?
          chain[index]
        else
          chain[index]- chain[index - 1]
        end

      case diff
      when 1
        acc[:num_1s] += 1
      when 2
        acc[:num_2s] += 1
      when 3
        acc[:num_3s] += 1
      else
        raise "Bad diff found #{diff} at index #{index}"
      end

      acc
    end
  end
end
