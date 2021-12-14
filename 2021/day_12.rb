require 'pry'
require 'set'
require_relative 'lib/read_file'

class Cave
  attr_reader :links, :name

  def initialize(name)
    @links = Set.new
    @name = name
  end

  def small?
    @name.match(/[a-z]+/)
  end

  def add_link(cave)
    @links.add(cave)
  end

  def paths_to_end(path: [], num_stops: 1)
    return [Array.new(path) << self] if name == 'end'
    return [] if path.any? && name == 'start'

    if small? &&
        path.select(&:small?).map(&:name).tally.invert[num_stops] &&
        Set.new(path).include?(self)
      return []
    end

    @links.flat_map do |link|
      link.paths_to_end(
        path: Array.new(path) << self,
        num_stops: num_stops,
      )
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

  def paths(num_stops = 1)
    @caves['start'].paths_to_end(num_stops: num_stops)
  end
end

def do_part_1
  graph = Graph.new
  puts graph.paths.size
end


def do_part_2
  puts Graph.new.paths(2).size
end

puts 'PART 1'
do_part_1 # 3887

puts 'PART 2'
do_part_2 # 104834
