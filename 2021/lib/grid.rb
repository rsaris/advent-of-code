require_relative 'read_file'

def read_grid(file_name)
  read_file(file_name) { |line| line.split('').map(&:to_i) }
end

def print_grid(grid)
  grid.map { |row| row.map { |val| val == 0 ? '*' : val }.join }.join("\n")
end
