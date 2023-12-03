require_relative './lib/read_file'

class Game < Struct.new(:id, :pulls, keyword_init: true)
  def max_green
    max_color('green')
  end

  def max_blue
    max_color('blue')
  end

  def max_red
    max_color('red')
  end

  private

  def max_color(color)
    pulls.reduce(0) do |acc, pull|
      pull_match = pull.match(/(?<num_cubes>\d+) #{color}/)
      if pull_match && pull_match['num_cubes'].to_i > acc
        pull_match['num_cubes'].to_i
      else
        acc
      end
    end
  end
end

def build_games
  read_file('day_2.txt') do |line|
    line_match = line.match(/Game (?<id>\d*):(?<pulls>.*)/)
    Game.new(
      id: line_match['id'].to_i,
      pulls: line_match['pulls']&.split(';')&.map(&:strip) || []
    )
  end
end

def do_part_1
  puts (build_games.select do |game|
    game.max_red <= 12 &&
      game.max_green <= 13 &&
      game.max_blue <= 14
  end).sum(&:id)
end

def do_part_2
  puts build_games.sum { |game| game.max_blue * game.max_green * game.max_red }
end

do_part_1 #2913
do_part_2 #55593
