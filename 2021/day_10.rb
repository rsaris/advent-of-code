require_relative 'lib/read_file'

class CommandLine
  attr_reader :debug, :line

  def initialize(line, debug: false)
    @debug = debug
    @line = line
  end

  def corrupted_syntax_score
    processed_line = process_line
    return 0 if processed_line.is_a?(Array)

    corrupted_char_score(processed_line)
  end

  def incomplete_syntax_score
    processed_line = process_line
    return nil unless processed_line.is_a?(Array)

    processed_line.reverse.reduce(0) { |acc, char| acc * 5 + incomplete_char_score(char) }
  end

  private

  def closing_char(opening_char)
    case opening_char
    when '('
      ')'
    when '['
      ']'
    when '{'
      '}'
    when '<'
      '>'
    end
  end

  def corrupted_char_score(closing_char)
    case closing_char
    when ')'
      3
    when ']'
      57
    when '}'
      1197
    when '>'
      25137
    else
      raise "Unexpected corrupted char #{closing_char}"
    end
  end

  def incomplete_char_score(opening_char)
    '.([{<'.index(opening_char)
  end

  def process_line
    open_chunks = []
    line.split('').each_with_index do |char, index|
      if ['(', '[', '{', '<'].include?(char)
        open_chunks << char
      elsif open_chunks.empty?
        raise "Found closing character #{char} with no open chunk at #{index}"
      else
        open_char = open_chunks.pop
        if char != closing_char(open_char)
          puts "Found corrupted character #{char} at #{index}, expecting to close #{open_char}" if debug
          return char
        end
      end
    end

    puts "Found complete line #{line}" if debug
    return open_chunks
  end
end

def read_inputs
  read_file('day_10.txt') { |line| CommandLine.new(line) }
end

def do_part_1
  puts read_inputs.map(&:corrupted_syntax_score).sum
end

def do_part_2
  incomplete_scores = read_inputs.map(&:incomplete_syntax_score).compact.sort
  puts incomplete_scores[incomplete_scores.compact.size / 2]
end

puts 'PART 1'
do_part_1 # 319329

puts 'PART 2'
do_part_2 # 3515583998
