require_relative 'lib/read_inputs'

class FerryPath
  attr_reader :instructions,
    :dir,
    :waypoint_x,
    :waypoint_y,
    :x,
    :y

  def initialize(file_path)
    @instructions = read_inputs(file_path)
  end

  def follow_basic_instructions
    @dir = @x = @y = 0
    instructions.each { |instruction| move_basic(instruction) }
  end

  def follow_advanced_instructions
    @x = @y = 0
    @waypoint_x = 10
    @waypoint_y = 1

    @instructions.each { |instruction| move_advanced(instruction) }
  end

  private

  def match_instruction(instruction)
    instruction.match(/(?<move>[NSEWLRF])(?<amount>\d*)/)
  end

  def move_basic(instruction)
    match = match_instruction(instruction)

    move = match['move']
    if move == 'F'
      move =
        case dir
        when 0
          'E'
        when 90
          'S'
        when 180
          'W'
        when 270
          'N'
        else
          raise "Unknown direction #{dir} on instruction #{instruction}"
        end
    end

    case move
    when 'N'
      @y += match['amount'].to_i
    when 'S'
      @y -= match['amount'].to_i
    when 'E'
      @x += match['amount'].to_i
    when 'W'
      @x -= match['amount'].to_i
    when 'L'
      @dir = (@dir - match['amount'].to_i) % 360
    when 'R'
      @dir = (@dir + match['amount'].to_i) % 360
    else
      raise "Unknown instruction #{instruction}"
    end
  end

  def move_advanced(instruction)
    match = match_instruction(instruction)

    case match['move']
    when 'N'
      @waypoint_y += match['amount'].to_i
    when 'S'
      @waypoint_y -= match['amount'].to_i
    when 'E'
      @waypoint_x += match['amount'].to_i
    when 'W'
      @waypoint_x -= match['amount'].to_i
    when 'R', 'L'
      amount =
        if match['move'] == 'L'
          360 - match['amount'].to_i
        else
          match['amount'].to_i
        end

      old_waypoint_y = @waypoint_y

      case amount % 360
      when 0
        # no-op
      when 90
        @waypoint_y = @waypoint_x * -1
        @waypoint_x = old_waypoint_y
      when 180
        @waypoint_y = @waypoint_y * -1
        @waypoint_x = @waypoint_x * -1
      when 270
        @waypoint_y = @waypoint_x
        @waypoint_x = old_waypoint_y * -1
      else
        raise "Bad rotation found #{instruction}"
      end
    when 'F'
      @x += (@waypoint_x * match['amount'].to_i)
      @y += (@waypoint_y * match['amount'].to_i)
    end
  end
end

def do_part_1
  path = FerryPath.new('day-12.txt')
  path.follow_basic_instructions

  puts path.x.abs + path.y.abs
end

def do_part_2
  path = FerryPath.new('day-12.txt')
  path.follow_advanced_instructions

  puts path.x.abs + path.y.abs
end


do_part_1 # 757
do_part_2 # 51249
