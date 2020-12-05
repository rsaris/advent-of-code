require_relative 'read_inputs'

class BoardingPass
  attr_reader :ticket_number

  def initialize(ticket_number)
    @ticket_number = ticket_number
  end

  def seat_id
    ticket_number
      .gsub('B', '1')
      .gsub('F', '0')
      .gsub('R', '1')
      .gsub('L', '0')
      .to_i(2)
  end

  def row
    ticket_number[0..6].gsub('B', '1').gsub('F', '0').to_i(2)
  end

  def seat
    ticket_number[7..9].gsub('R', '1').gsub('L', '0').to_i(2)
  end
end

def read_boarding_passes(file_name)
  inputs = read_inputs(file_name)

  inputs.map { |row| BoardingPass.new(row) }
end

def run_test(file_name)
  read_boarding_passes(file_name).each { |bp| raise "BAD DATA: #{bp.ticket_number}" if bp.seat_id != (bp.row * 8 + bp.seat) }
end
