require_relative './lib/read_file'

require 'pry'

Item = Struct.new(:worry_level)

Monkey = Struct.new(
  :items,
  :operation,
  :test,
  :true_monkey,
  :false_monkey,
  :num_inspections,
  keyword_init: true
) do
  def initialize(items:, operation:, test:, true_monkey: nil, false_monkey: nil, num_inspections: 0)
    super
  end

  def take_turn(part_2)
    items.each do |item|
      item.worry_level = operation.call(item.worry_level)
      if part_2
        item.worry_level = item.worry_level % (2 * 3 * 5 * 7 * 11 * 13 * 17 * 19)
      else
        item.worry_level = item.worry_level / 3
      end

      if item.worry_level % test == 0
        true_monkey.items << item
      else
        false_monkey.items << item
      end
      self.num_inspections = num_inspections + 1
    end

    self.items = []
  end
end

def build_monkeys
  monkeys = [
    Monkey.new(
      items: [99, 67, 92, 61, 83, 64, 98].map { |i| Item.new(i) },
      operation: ->(worry_level) { worry_level * 17 },
      test: 3,
    ),
    Monkey.new(
      items: [78, 74, 88, 89, 50].map { |i| Item.new(i) },
      operation: ->(worry_level) { worry_level * 11 },
      test: 5,
    ),
    Monkey.new(
      items: [98, 91].map { |i| Item.new(i) },
      operation: ->(worry_level) { worry_level + 4 },
      test: 2,
    ),
    Monkey.new(
      items: [59, 72, 94, 91, 79, 88, 94, 51].map { |i| Item.new(i) },
      operation: ->(worry_level) { worry_level * worry_level },
      test: 13,
    ),
    Monkey.new(
      items: [95, 72, 78].map { |i| Item.new(i) },
      operation: ->(worry_level) { worry_level + 7 },
      test: 11,
    ),
    Monkey.new(
      items: [76].map { |i| Item.new(i) },
      operation: ->(worry_level) { worry_level + 8 },
      test: 17,
    ),
    Monkey.new(
      items: [69, 60, 53, 89, 71, 88].map { |i| Item.new(i) },
      operation: ->(worry_level) { worry_level + 5},
      test: 19,
    ),
    Monkey.new(
      items: [72, 54, 63, 80].map { |i| Item.new(i) },
      operation: ->(worry_level) { worry_level + 3 },
      test: 7,
    ),
  ]

  monkeys[0].true_monkey = monkeys[4]
  monkeys[0].false_monkey = monkeys[2]

  monkeys[1].true_monkey = monkeys[3]
  monkeys[1].false_monkey = monkeys[5]

  monkeys[2].true_monkey = monkeys[6]
  monkeys[2].false_monkey = monkeys[4]

  monkeys[3].true_monkey = monkeys[0]
  monkeys[3].false_monkey = monkeys[5]

  monkeys[4].true_monkey = monkeys[7]
  monkeys[4].false_monkey = monkeys[6]

  monkeys[5].true_monkey = monkeys[0]
  monkeys[5].false_monkey = monkeys[2]

  monkeys[6].true_monkey = monkeys[7]
  monkeys[6].false_monkey = monkeys[1]

  monkeys[7].true_monkey = monkeys[1]
  monkeys[7].false_monkey = monkeys[3]

  monkeys
end

def do_round(monkeys, part_2: false)
  monkeys.each_with_index do |monkey, round|
    monkey.take_turn(part_2)
  end
end

def print_monkeys(monkeys)
  monkeys.each_with_index do |monkey, index|
    puts "Monkey #{index}: #{monkey.items.map(&:worry_level).join(', ')}"
  end
end

def do_part_1
  monkeys = build_monkeys
  (1..20).each do |round|
    do_round(monkeys)
  end
  sorted_monkeys = monkeys.sort_by(&:num_inspections)
  puts sorted_monkeys[-1].num_inspections * sorted_monkeys[-2].num_inspections
end

def do_part_2
  monkeys = build_monkeys
  (1..10000).each do |round|
    do_round(monkeys, part_2: true)
  end
  sorted_monkeys = monkeys.sort_by(&:num_inspections)
  puts sorted_monkeys[-1].num_inspections * sorted_monkeys[-2].num_inspections
end

puts 'PART 1'
do_part_1 # 120384

puts 'PART 2'
do_part_2 # 32059801242
