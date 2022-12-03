require_relative './lib/read_file'

ROCK = 1
PAPER = 2
SCISSORS = 3

OUTCOME_LOSS = 'X'
OUTCOME_DRAW = 'Y'
OUTCOME_WIN = 'Z'

SCORE_LOSS = 0
SCORE_DRAW = 3
SCORE_WIN = 6

OPP_THROWS = {
  'A' => ROCK,
  'B' => PAPER,
  'C' => SCISSORS,
}

MY_THROWS = {
  'X' => ROCK,
  'Y' => PAPER,
  'Z' => SCISSORS,
}

THROW_MATRIX = {
  'A' => { OUTCOME_LOSS => 'Z', OUTCOME_DRAW => 'X', OUTCOME_WIN => 'Y' },
  'B' => { OUTCOME_LOSS => 'X', OUTCOME_DRAW => 'Y', OUTCOME_WIN => 'Z' },
  'C' => { OUTCOME_LOSS => 'Y', OUTCOME_DRAW => 'Z', OUTCOME_WIN => 'X' },
}


def round_score(opp_throw, my_throw)
  if OPP_THROWS[opp_throw] == MY_THROWS[my_throw]
    SCORE_DRAW
  elsif OPP_THROWS[opp_throw] == ROCK && MY_THROWS[my_throw] == SCISSORS
    SCORE_LOSS
  elsif MY_THROWS[my_throw] == ROCK && OPP_THROWS[opp_throw] == SCISSORS
    SCORE_WIN
  else
    MY_THROWS[my_throw] > OPP_THROWS[opp_throw] ? SCORE_WIN : SCORE_LOSS
  end
end

def do_part_1
  lines = read_file('day_2.txt')
  total = 0
  lines.each do |line|
    opp_throw, my_throw = line.split(' ')
    total += MY_THROWS[my_throw] + round_score(opp_throw, my_throw)
  end

  puts total
end

def do_part_2
  lines = read_file('day_2.txt')
  total = 0
  lines.each do |line|
    opp_throw, desired_outome = line.split(' ')
    my_throw = THROW_MATRIX[opp_throw][desired_outome]
    total += MY_THROWS[my_throw] + round_score(opp_throw, my_throw)
  end

  puts total
end

puts 'PART 1'
do_part_1 # 9177

puts 'PART 2'
do_part_2 # 12111
