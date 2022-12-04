require_relative './lib/read_file'

def get_areas(batch_string)
  start, finish = batch_string.split('-').map(&:to_i)
  (start..finish).to_a
end

def do_part_1
  lines = read_file('day_4.txt')

  num_overlaps = 0
  lines.each do |line|
    first_batch, second_batch = line.split(',')
    first_batch_areas = get_areas(first_batch)
    second_batch_areas = get_areas(second_batch)
    common_areas = first_batch_areas & second_batch_areas

    if common_areas == first_batch_areas || common_areas == second_batch_areas
      num_overlaps += 1
    end
  end

  puts num_overlaps
end

def do_part_2
  lines = read_file('day_4.txt')

  num_overlaps = 0
  lines.each do |line|
    first_batch, second_batch = line.split(',')
    first_batch_areas = get_areas(first_batch)
    second_batch_areas = get_areas(second_batch)

    if (first_batch_areas & second_batch_areas).any?
      num_overlaps += 1
    end
  end

  puts num_overlaps
end

puts 'Part 1'
do_part_1 # 509

puts 'Part 2'
do_part_2 # 870
