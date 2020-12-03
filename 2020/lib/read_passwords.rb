require_relative 'read_inputs'

class Password
  attr_reader :password, :letter, :criteria_1, :criteria_2

  def initialize(password, letter, criteria_1, criteria_2)
    @password = password
    @letter = letter
    @criteria_1 = criteria_1
    @criteria_2 = criteria_2
  end

  def min_max_valid?
    num_matching_letters = password.length - password.gsub(letter, '').length
    num_matching_letters >= criteria_1 && num_matching_letters <= criteria_2
  end

  def positions_valid?
    (position_is_letter?(criteria_1) ? 1 : 0) + (position_is_letter?(criteria_2) ? 1 : 0) == 1
  end

  private

  def position_is_letter?(position)
    password[position -1] == letter
  end
end

def read_passwords(file_name)
  rows = read_inputs(file_name)

  rows.map do |row|
    criteria, letter, password = row.split(' ')
    letter = letter.gsub(':', '')
    criteria_1, criteria_2 = criteria.split('-').map!(&:to_i)

    Password.new(password, letter, criteria_1, criteria_2)
  end
end
