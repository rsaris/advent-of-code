require 'pry'
require_relative 'lib/grid'

class OctopusGrid
  attr_reader :debug, :grid, :num_flashes

  def initialize(grid, debug: false)
    @debug = debug
    @grid = grid
    @num_flashes = 0
  end

  def run_step
    (0..grid.size - 1).each do |row_index|
      (0..grid[row_index].size - 1).each do |col_index|
        increment_coord(row_index, col_index)
      end
    end

    num_flashes_this_step = 0

    (0..grid.size - 1).each do |row_index|
      (0..grid[row_index].size - 1).each do |col_index|
        if grid[row_index][col_index] == 10
          num_flashes_this_step += 1
          grid[row_index][col_index] = 0
        end
      end
    end

    @num_flashes += num_flashes_this_step

    num_flashes_this_step == grid.size * grid[0].size
  end

  private

  def increment_coord(row_index, col_index)
    cur_cell = grid[row_index][col_index]
    return if cur_cell == 10

    grid[row_index][col_index] += 1
    process_flash(row_index, col_index) if grid[row_index][col_index] == 10
  end

  def process_flash(row_index, col_index)
    if grid[row_index][col_index] != 10
      binding.pry
      puts print_grid(grid)
      raise "BAD FLASH #{row_index}, #{col_index}"
    end

    first_row = row_index == 0
    last_row = row_index == grid.size - 1
    first_col = col_index == 0
    last_col = col_index == grid[row_index].size - 1

    coords_to_process = []

    if !first_row
      increment_coord(row_index - 1, col_index)
      if !first_col
        increment_coord(row_index - 1, col_index - 1)
      end
      if !last_col
        increment_coord(row_index - 1, col_index + 1)
      end
    end

    if !last_row
      increment_coord(row_index + 1, col_index)
      if !first_col
        increment_coord(row_index + 1, col_index - 1)
      end
      if !last_col
        increment_coord(row_index + 1, col_index + 1)
      end
    end

    if !first_col
      increment_coord(row_index, col_index - 1)
    end

    if !last_col
      increment_coord(row_index, col_index + 1)
    end
  end
end

def build_grid(debug)
  grid = OctopusGrid.new(read_grid(debug ? 'day_11.debug.txt' : 'day_11.txt'), debug: debug)
  puts '--- INITIAL GRID ---' if debug
  puts print_grid(grid.grid) if debug

  grid
end

def do_part_1
  debug = false
  grid = build_grid(debug)

  (debug ? 10 : 100).times do |index|
    grid.run_step

    puts "--- RUN #{index + 1} ---" if debug
    puts print_grid(grid.grid) if debug
  end

  puts grid.num_flashes
end

def do_part_2
  debug = false
  grid = build_grid(debug)

  cur_step = 1
  until grid.run_step
    puts "Running step #{cur_step}" if debug
    cur_step += 1
  end

  puts cur_step
end

puts 'PART 1'
do_part_1 # 1700

puts 'PART 2'
do_part_2 # 273
