class Submarine
  DIR_FORWARD = 'forward'
  DIR_DOWN = 'down'
  DIR_UP = 'up'

  attr_reader :x, :y

  def initialize
    reset_position
  end

  def reset_position
    @x = 0
    @y = 0
  end

  def follow_simple_instructions(instructions)
    instructions.each do |instruction|
      dir, amount = instruction.split(' ')
      amount = amount.to_i
      case dir
      when DIR_FORWARD
        @x += amount
      when DIR_UP
        @y -= amount
      when DIR_DOWN
        @y += amount
      else
        raise "Unknown direction #{dir} (AMOUNT = #{amount})"
      end
    end
  end
end
