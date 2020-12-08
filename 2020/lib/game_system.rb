require_relative 'read_inputs'
require 'set'

COMMAND_ACC = 'acc'
COMMAND_JMP = 'jmp'
COMMAND_NOP = 'nop'

EXIT_SUCCESS = 0
EXIT_LOOP = 1

class Command
  attr_reader(
    :amount,
    :command,
    :command_string,
    :index,
  )

  def initialize(command_string, index)
    @command_string = command_string
    @index = index

    parsed_command = command_string.match(/(?<command>[a-z]*) (?<amount>[+-]\d*)/)

    @amount = parsed_command['amount'].to_i
    @command = parsed_command['command']
  end

  def next
    command == COMMAND_JMP ? index + amount : index + 1
  end

  def swap_commands
    @command = command == COMMAND_JMP ? COMMAND_NOP : COMMAND_JMP
  end
end

class GameSystem
  attr_reader(
    :commands,
    :commands_hit,
    :counter,
    :cur_index,
  )

  def initialize(file_name)
    @commands =
      read_inputs(file_name).each_with_index.map do |input, index|
        Command.new(input, index)
      end
  end

  def find_loop_fix
    run_program # Seed the potential commands to update
    commands_hit.to_a.each do |adjusted_command_index|
      adjusted_command = commands[adjusted_command_index]
      next if adjusted_command.command == COMMAND_ACC # Ignore acc, they're safe
      next if adjusted_command.command == COMMAND_NOP && adjusted_command.amount == 0 # Ignore self loops

      adjusted_command.swap_commands
      return if run_program == EXIT_SUCCESS

      adjusted_command.swap_commands # Put the command back where it was
    end
  end

  def run_program
    reset

    while keep_running?
      return EXIT_LOOP if commands_hit.include?(cur_index)
      commands_hit.add(cur_index)
      execute_command(commands[cur_index])
    end

    return EXIT_SUCCESS
  end

  private

  def execute_command(command)
    if command.command == 'acc'
      @counter += command.amount
    end

    @cur_index = command.next
  end

  def keep_running?
    cur_index != commands.size
  end

  def reset
    @commands_hit = Set.new
    @counter = 0
    @cur_index = 0
  end
end
