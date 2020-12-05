require_relative 'lib/read_boarding_passes'

def do_part_1
  puts read_boarding_passes('day-5.txt').max_by(&:seat_id).seat_id
end

def do_part_2
  boarding_passes = read_boarding_passes('day-5.txt').sort_by!(&:seat_id)

  (1..boarding_passes.length).each do |index|
    boarding_pass = boarding_passes[index]
    if boarding_pass.seat_id != (boarding_passes[index-1].seat_id + 1)
      puts boarding_pass.seat_id - 1
      return
    end
  end
end

do_part_1 # 994
do_part_2 # 741
