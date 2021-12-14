require 'pry'
require 'set'
require_relative 'lib/read_file'

class Cave
  attr_reader :links, :name

  def initialize(name)
    @links = Set.new
    @name = name
  end

  def big?
    @name.match(/[A-Z]+/)
  end

  def add_link(cave)
    @links.add(cave)
  end

  def paths_to_end(path = [])
    # binding.pry
    return [Array.new(path) << self] if name == 'end'

    @links.reduce([]) do |acc, link|
      caves_to_ignore = Set.new(path.reject(&:big?))

      unless caves_to_ignore.include?(link)
        acc.concat(link.paths_to_end(Array.new(path) << self))
      end

      acc
    end
  end
end

class Graph
  def initialize
    @caves = {}

    read_file('day_12.txt') do |line|
      first_cave_name, second_cave_name = line.split('-')

      first_cave = @caves[first_cave_name] ||= Cave.new(first_cave_name)
      second_cave = @caves[second_cave_name] ||= Cave.new(second_cave_name)

      first_cave.add_link(second_cave)
      second_cave.add_link(first_cave)
    end
  end

  def paths
    @caves['start'].paths_to_end
  end
end

def do_part_1
  graph = Graph.new
  puts graph.paths.size
end

puts 'PART 1'
do_part_1 # 3887
