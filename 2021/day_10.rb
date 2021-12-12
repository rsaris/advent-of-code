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

    case processed_line
    when ')'
      3
    when ']'
      57
    when '}'
      1197
    when '>'
      25137
    else
      0
    end
  end

  private

  def closes_chunk?(opening_char, closing_char)
    (opening_char == '(' && closing_char == ')') ||
      (opening_char == '[' && closing_char == ']') ||
      (opening_char == '{' && closing_char == '}') ||
      (opening_char == '<' && closing_char == '>')
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
        if !closes_chunk?(open_char, char)
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

puts 'PART 1'
do_part_1 # 319329
