require_relative 'read_inputs'

class AdapterSet
  attr_reader :adapters

  def initialize(file_name)
    @adapters = read_inputs(file_name, map_method: :to_i).sort!
  end

  def num_chains
    @chain_memo = {}
    chains_available(adapters.unshift(0))
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

  private

  def chains_available(chain)
    current_value = chain[0]
    return @chain_memo[current_value] if @chain_memo[current_value]

    num_chains =
      if chain.size <= 1
        1
      else
        chains_available(chain[1..-1]) +
          ((chain.size > 2 && chain[2] - current_value <= 3) ? chains_available(chain[2..-1]) : 0) +
          ((chain.size > 3 && chain[3] - current_value <= 3) ? chains_available(chain[3..-1]) : 0)
      end

    @chain_memo[current_value] = num_chains
  end
end
