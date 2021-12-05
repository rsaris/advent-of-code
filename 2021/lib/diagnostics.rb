class Diagnostics
  attr_reader :diagnostic_report

  def initialize(diagnostic_report)
    @diagnostic_report = diagnostic_report
  end

  def calculate_rates
    num_inputs = diagnostic_report.size

    bit_counts = []
    diagnostic_report.each do |input|
      input.split('').each_with_index do |bit, pos|
        bit_counts[pos] ||= 0
        if bit == '1'
          bit_counts[pos] += 1
        end
      end
    end

    gamma = ''
    epsilon = ''

    bit_counts.each do |count|
      if count >= (num_inputs / 2.0)
        gamma += '1'
        epsilon += '0'
      else
        gamma += '0'
        epsilon += '1'
      end
    end

    [gamma, epsilon]
  end
end
