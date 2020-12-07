require_relative 'read_inputs'

class BagRules
  attr_reader(
    :child_bags, # Map from bag name -> bag name -> amount
    :parent_bags, # Map from bag name -> bag name -> amount
  )

  def initialize
    @child_bags = Hash.new
    @parent_bags = Hash.new
  end

  def add_rule(input)
    return if input.match(/no other bags.\z/)

    parent_name, rules = input.split(' bags contain ')

    rules.chomp('.').split(', ').each do |rule|
      match = rule.match(/(?<amount>\d+) (?<name>.*) bag[s]?/)

      @parent_bags[parent_name] ||= {}
      @child_bags[match['name']] ||= {}

      @parent_bags[parent_name][match['name']] = match['amount'].to_i
      @child_bags[match['name']][parent_name] = match['amount'].to_i
    end
  end

  def available_parent_bags(bag_name)
    names = []
    names_to_process = [bag_name]

    while names_to_process.any?
      cur_name = names_to_process.pop
      (child_bags[cur_name]&.keys || []).each do |parent_bag|
        next if parent_bag == bag_name || names.include?(parent_bag) # If we already found this one, skip it
        names << parent_bag
        names_to_process << parent_bag
      end
    end

    names.size
  end

  def required_bags(bag_name)
    1 + (parent_bags[bag_name]&.sum do |bag_rule|
      bag_rule[1] * required_bags(bag_rule[0])
    end || 0)
  end
end

def read_bag_rules(file_name)
  rules = BagRules.new

  read_inputs(file_name).each do |input|
    rules.add_rule(input)
  end

  rules
end
