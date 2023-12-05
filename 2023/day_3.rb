require_relative './lib/read_file'

class PossibleGears < Struct.new(:row, :col, :nums, keyword_init: true)
  def initialize(row:, col:, nums: [])
    super
  end
end

def has_symbol(string)
  string.gsub(/[\.\d]/, '').length > 0
end

def has_astrisk(string)
  string.gsub('[^*]', '').length > 0
end

def do_part_1
  lines = read_file('day_3.txt')
  puts(
    lines.each_with_index.map do |line, index|
      line.enum_for(:scan, /\d+/).reduce(0) do |acc|
        last_match = Regexp.last_match
        num = last_match.to_s
        num_start = last_match.offset(0).first

        check_start = num_start == 0 ? 0 : num_start - 1
        check_end =
          (num_start + num.length) == line.length ?
            line.length - 1 :
            num_start + num.length

        if index != 0 && has_symbol(lines[index - 1][check_start..check_end])
          acc + num.to_i
        elsif has_symbol(lines[index][check_start..check_end])
          acc + num.to_i
        elsif index != lines.length - 1 && has_symbol(lines[index + 1][check_start..check_end])
          acc + num.to_i
        else
          acc
        end
      end
    end.sum
  )
end

def do_part_2
  lines = read_file('day_3.txt')
  gears = []
  gear_lookup = {}

  lines.each_with_index do |line, index|
    line.enum_for(:scan, /\d+/).reduce(0) do |acc|
      last_match = Regexp.last_match
      num = last_match.to_s
      num_start = last_match.offset(0).first

      check_start = num_start == 0 ? 0 : num_start - 1
      check_end =
        (num_start + num.length) == line.length ?
          line.length - 1 :
          num_start + num.length

      if index != 0 && has_astrisk(lines[index - 1][check_start..check_end])
        prev_line = lines[index - 1][check_start..check_end]
        prev_line.enum_for(:scan, /\*/).each do
          last_astrisk_match = Regexp.last_match
          
      elsif has_astrisk(lines[index][check_start..check_end])
        acc + num.to_i
      elsif index != lines.length - 1 && has_astrisk(lines[index + 1][check_start..check_end])
        acc + num.to_i
      else
        acc
      end
    end
  end

  puts gears.filter { _1.nums.size == 2 }.map { _1.nums[0] * _1.nums[1] }.sum
end

do_part_1 # 551094
do_part_2 #
