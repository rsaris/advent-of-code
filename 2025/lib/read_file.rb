def read_file(file_name, &block)
  lines = File.open("./inputs/#{file_name}").read.split("\n")
  lines = lines.map { |line| yield(line) } if block
  lines
end
