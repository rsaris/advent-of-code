require_relative './lib/read_file'

require 'pry'

COMMAND_REGEX = /^(?<command>(noop)|(addx)) ?(?<param>.*)$/

class Computer
  attr_reader :cycle, :register

  def initialize
    @cycle = 1
    @register = 1
    @commands = read_file('day_10.txt')
    @command_index = 0
    @adding = false
  end

  def run_cycle
    command_match = @commands[@command_index].match(COMMAND_REGEX)

    if @adding
      @register += command_match['param'].to_i
      @command_index += 1
      @adding = false
    elsif command_match['command'] == 'noop'
      @command_index += 1
    elsif command_match['command'] == 'addx'
      @adding = true
    end

    @cycle += 1
  end
end

def print_screen(screen)
  puts screen.map { |row| row.map { |cell| cell ? '#' : '.' }.join('') }.join("\n")
end

def do_part_1
  tracked_value = 0
  computer = Computer.new

  (1..220).each do |cycle|
    if [20, 60, 100, 140, 180, 220].include?(computer.cycle)
      tracked_value += computer.register * computer.cycle
    end

    computer.run_cycle
  end

  puts tracked_value
end

def do_part_2
  screen = [
    Array.new(40),
    Array.new(40),
    Array.new(40),
    Array.new(40),
    Array.new(40),
    Array.new(40),
  ]
  computer = Computer.new

  (0...240).each do |cycle|
    if (computer.register - 1..computer.register + 1).include?(cycle % 40)
      screen[cycle / 40][cycle % 40] = true
    end
    computer.run_cycle
  end

  print_screen(screen)
end

puts 'PART 1'
do_part_1 # 17180

puts 'PART 2'
do_part_2 # REHPRLUB
