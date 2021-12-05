class Diagnostics
  attr_reader :debug, :diagnostic_report

  def initialize(diagnostic_report, debug: false)
    @debug = debug
    @diagnostic_report = diagnostic_report
  end

  def calculate_rates
    calculate_rates_from_inputs(diagnostic_report)
  end

  def calculate_ratings
    oxygen_inputs = diagnostic_report.dup
    carbon_dioxide_inputs = diagnostic_report.dup

    cur_pos = 0
    while oxygen_inputs.size > 1 || carbon_dioxide_inputs.size > 1
      cur_pos = 0 if cur_pos > (oxygen_inputs[0].size - 1)
      puts "[DEBUG] Looking at #{cur_pos}" if debug

      if oxygen_inputs.size > 1
        gamma, _ = calculate_rates_from_inputs(oxygen_inputs)
        puts "[DEBUG] Found gamma #{gamma}" if debug
        oxygen_inputs = oxygen_inputs.select { |input| input[cur_pos] == gamma[cur_pos] }
        puts "[DEBUG] Filtered to #{oxygen_inputs.join(', ')}" if debug
      end

      if carbon_dioxide_inputs.size > 1
        _, epsilon = calculate_rates_from_inputs(carbon_dioxide_inputs)
        puts "[DEBUG] Found espsilon #{epsilon}" if debug
        carbon_dioxide_inputs = carbon_dioxide_inputs.select { |input| input[cur_pos] == epsilon[cur_pos] }
        puts "[DEBUG] Filtered to #{carbon_dioxide_inputs.join(', ')}" if debug
      end

      cur_pos += 1
    end

    [oxygen_inputs.first, carbon_dioxide_inputs.first]
  end

  private

  def calculate_rates_from_inputs(inputs)
    num_inputs = inputs.size

    bit_counts = []
    inputs.each do |input|
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
