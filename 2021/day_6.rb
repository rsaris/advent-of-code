require_relative 'lib/read_file'

def run_sim(num_days)
  debug = false

  inputs = read_file('day_6.txt')[0].split(',').map(&:to_i)
  spawn_days = [0, 0, 0, 0, 0, 0, 0]
  inputs.each do |input|
    spawn_days[input] += 1
  end

  puts "Found fish spawning at #{spawn_days.join(',')}" if debug

  days_out_2 = 0
  day_out_1 = 0

  num_days.times do |i|
    spawn_day = i % 7
    puts "DAY #{i}: Running day #{spawn_day} -- found #{spawn_days[spawn_day]} fish for today" if debug

    day_out_1_cache = day_out_1
    day_out_1 = days_out_2
    days_out_2 = spawn_days[spawn_day]
    spawn_days[spawn_day] += day_out_1_cache

    puts "DAY #{i}: At end of day have spawn days #{spawn_days.join(', ')}" if debug
    puts "DAY #{i}: 1 day away have #{day_out_1}" if debug
    puts "DAY #{i}: 2 day away we have #{days_out_2}" if debug
  end

  puts spawn_days.sum + day_out_1 + days_out_2
end

def do_part_1
  run_sim(80)
end

def do_part_2
  run_sim(256)
end

puts 'PART 1'
do_part_1 # 359999

puts 'PART 2'
do_part_2 # 1631647919273
