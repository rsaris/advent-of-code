def read_inputs(file_name, map_method: nil)
  input_lines = File.open("./inputs/#{file_name}").read.split("\n")
  input_lines.map!(&map_method) if map_method
  input_lines
end
