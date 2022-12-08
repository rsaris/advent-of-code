require 'pry'

require_relative './lib/read_file'

COMMAND_REGEX = /^\$ (?<command>(cd|ls)) ?(?<param>.*)$/
DIR_REGEX = /^dir (?<name>.+)$/
FILE_REGEX = /^(?<size>\d+) (?<name>.+)$/

TOTAL_SPACE = 70000000
NEEDED_SPACE = 30000000

FSFile = Struct.new(:name, :size, keyword_init: true)

FSDirectory = Struct.new(:name, :parent, keyword_init: true) do
  def children
    @children ||= {}
  end

  def path
    return '/' if parent.nil?

    @path ||= "#{parent.path}#{name}/"
  end

  def size
    return 0 if @children.none?

    @size ||= @children.values.map(&:size).sum
  end
end

class FileSystem
  attr_reader :directories

  def initialize(input_file)
    @lines = read_file(input_file)
    @root_directory = FSDirectory.new(name: '', parent: nil)
    @directories = { '/' => @root_directory }

    process_input
  end

  def size
    @root_directory.size
  end

  private

  def process_input
    @current_directory = @root_directory

    for current_line in @lines
      if (command_match = current_line.match(COMMAND_REGEX))
        if command_match['command'] == 'cd'
          if command_match['param'] == '/'
            @current_directory = @root_directory
          elsif command_match['param'] == '..'
            @current_directory = @current_directory.parent
          else
            @current_directory = @current_directory.children[command_match['param']]
          end
        end
      elsif (directory_match = current_line.match(DIR_REGEX))
        directory = FSDirectory.new(
          name: directory_match['name'],
          parent: @current_directory,
        )
        @directories[directory.path] = directory
        @current_directory.children[directory.name] = directory
      elsif (file_match = current_line.match(FILE_REGEX))
        file = FSFile.new(
          name: file_match['name'],
          size: file_match['size'].to_i,
        )
        @current_directory.children[file.name] = file
      else
        raise "Unexpected line found #{current_line} at index #{@current_line_index}"
      end
    end
  end
end

def do_part_1
  file_system = FileSystem.new('day_7.txt')
  small_dirs = file_system.directories.values.select { |dir| dir.size <= 100000 }

  puts small_dirs.map(&:size).sum
end

def do_part_2
  file_system = FileSystem.new('day_7.txt')
  used_space = file_system.size
  space_to_clear = NEEDED_SPACE - (TOTAL_SPACE - used_space)
  sorted_dirs = file_system.directories.values.sort { |dir| dir.size }.reverse
  sorted_dirs.each do |dir|
    if dir.size > space_to_clear
      puts dir.size
      return
    end
  end
end

puts 'PART 1'
do_part_1 # 1297159

puts 'PART 2'
do_part_2 # 3866390
