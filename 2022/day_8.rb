require_relative './lib/read_file'

require 'pry'

ScenicStats = Struct.new(:up, :down, :left, :right, keyword_init: true) do
  def score
    up * down * left * right
  end
end

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
  end

  def best_scenic_score
    build_scenic_scores

    @scenic_stats.map { |stats| stats.map(&:score).max }.max
  end

  def num_visible
    build_visibles if @visibiles.nil?

    @visibiles.sum do |row|
      row.sum { |tree| tree ? 1 : 0 }
    end
  end

  private

  def build_visibles
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

    @visibiles
  end

  def build_scenic_scores
    @scenic_stats = []
    (0...@heights.length).each do |height_index|
      @scenic_stats[height_index] = []

      prev_tree_indexes = []
      (0...@heights[height_index].length).each do |tree_index|
        # This is our first rodeo so create / save stats
        current_stats = ScenicStats.new
        @scenic_stats[height_index][tree_index] = current_stats

        current_height = @heights[height_index][tree_index]
        current_stats.left =
          if (blocking_tree_index = prev_tree_indexes[current_height..9]&.compact&.max)
            tree_index - blocking_tree_index
          else
            # we didn't find a blocking tree -- we see to the end
            tree_index
          end

        # Save this tree in the last indexes
        prev_tree_indexes[current_height] = tree_index
      end

      prev_tree_indexes = []
      (0...@heights[height_index].length).reverse_each do |tree_index|
        current_stats = @scenic_stats[height_index][tree_index]
        current_height = @heights[height_index][tree_index]
        current_stats.right =
          if (blocking_tree_index = prev_tree_indexes[current_height..9]&.compact&.max)
            blocking_tree_index - tree_index
          else
            # we didn't find a blocking tree -- we see to the end
            @heights[height_index].length - tree_index - 1
          end

        # Save this tree in the last indexes
        prev_tree_indexes[current_height] = tree_index
      end
    end

    # Top to Bottom
    (0...@heights[0].length).each do |tree_index|
      prev_height_indexes = []
      (0...@heights.length).each do |height_index|
        current_stats = @scenic_stats[height_index][tree_index]
        current_height = @heights[height_index][tree_index]
        current_stats.up =
          if (blocking_height_index = prev_height_indexes[current_height..9]&.compact&.max)
            height_index - blocking_height_index
          else
            # we didn't find a blocking tree -- we see to the end
            height_index
          end

        # Save this tree in the last indexes
        prev_height_indexes[current_height] = height_index
      end

      prev_height_indexes = []
      (0...@heights.length).reverse_each do |height_index|
        current_stats = @scenic_stats[height_index][tree_index]
        current_height = @heights[height_index][tree_index]
        current_stats.down =
          if (blocking_height_index = prev_height_indexes[current_height..9]&.compact&.max)
            blocking_height_index - height_index
          else
            # we didn't find a blocking tree -- we see to the end
            @heights.length - height_index - 1
          end

        # Save this tree in the last indexes
        prev_height_indexes[current_height] = height_index
      end
    end
  end
end

def do_part_1
  forest = Forest.new('day_8.txt')
  puts forest.num_visible
end

def do_part_2
  forest = Forest.new('day_8.txt')
  puts forest.best_scenic_score
end

puts 'PART 1'
do_part_1 # 1690

puts 'PART 2'
do_part_2 # 535680
