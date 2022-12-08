require_relative './lib/read_file'

require 'pry'

class Forest
  def initialize(input_file)
    lines = read_file(input_file)

    @heights = []
    (0...lines.length).each do |line_index|
      @heights[line_index] ||= []

      line = lines[line_index]
      (0...line.length).each do |char_index|
        @heights[line_index][char_index] = line[char_index].to_i
      end
    end

    @visibiles = []
    # Side to Side
    (0...@heights.length).each do |height_index|
      @visibiles[height_index] = []

      highest_tree = nil
      (0...@heights[height_index].length).each do |tree_index|
        current_height = @heights[height_index][tree_index]
        if highest_tree.nil? || current_height > highest_tree
          highest_tree = current_height
          @visibiles[height_index][tree_index] = true
        end
      end

      highest_tree = nil
      (0...@heights[height_index].length).reverse_each do |tree_index|
        current_height = @heights[height_index][tree_index]
        if highest_tree.nil? || current_height > highest_tree
          highest_tree = current_height
          @visibiles[height_index][tree_index] = true
        end
      end
    end

    # Top to Bottom
    (0...@heights[0].length).each do |tree_index|
      highest_tree = nil
      (0...@heights.length).each do |height_index|
        current_height = @heights[height_index][tree_index]
        if highest_tree.nil? || current_height > highest_tree
          highest_tree = current_height
          @visibiles[height_index][tree_index] = true
        end
      end

      highest_tree = nil
      (0...@heights.length).reverse_each do |height_index|
        current_height = @heights[height_index][tree_index]
        if highest_tree.nil? || current_height > highest_tree
          highest_tree = current_height
          @visibiles[height_index][tree_index] = true
        end
      end
    end
  end

  def num_visible
    @visibiles.sum do |row|
      row.sum { |tree| tree ? 1 : 0 }
    end
  end
end

def do_part_1
  forest = Forest.new('day_8.txt')
  puts forest.num_visible
end

puts 'PART 1'
do_part_1 # 1690
