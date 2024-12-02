require_relative './lib/read_file'

class ScratchCard < Struct.new(:winning_numbers, :card_numbers, keyword_init: true)
  def matching_numbers
    @matching_numbers ||= card_numbers.filter { |num| winning_numbers.include?(num) }
  end

  def winning_value
    if matching_numbers.length == 0
      0
    else
      2**(matching_numbers.length - 1)
    end
  end
end

def do_part_1
  cards = read_file('day_4.txt') do |line|
    match = line.match(/Card\s*\d+\: (?<winning_numbers>(\d|\s)+)\|(?<card_numbers>(\d|\s)+)/)
    begin
      ScratchCard.new(
        card_numbers: match['card_numbers'].strip.split(' ').map(&:to_i),
        winning_numbers: match['winning_numbers'].strip.split(' ').map(&:to_i),
      )
    rescue StandardError => e
      puts "LINE: #{line}"
      raise e
    end
  end.compact
  puts cards.sum(&:winning_value)
end

def do_part_2
end

do_part_1 # 21919
do_part_2
