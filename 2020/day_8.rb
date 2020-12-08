require_relative 'lib/game_system'

def do_part_1
  game_system = GameSystem.new('day-8.txt')
  game_system.run_program
  puts game_system.counter
end

def do_part_2
  game_system = GameSystem.new('day-8.txt')
  game_system.find_loop_fix
  puts game_system.counter
end

do_part_1 # 1489
do_part_2 # 1539
