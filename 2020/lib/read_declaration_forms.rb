require_relative 'read_inputs'

class DeclarationForm
  attr_reader :responses

  def initialize
    @responses = []
  end

  def num_unique_responses
    responses.map! { |r| r.split('') }.flatten.uniq.size
  end

  def num_exhaustive_responses
    responses.map! { |r| r.split('') }.reduce(nil) { |acc, response| acc ? (acc & response) : response }.size
  end
end

def read_declaration_forms(file_name)
  cur_declaration_form = DeclarationForm.new
  declaration_forms = [cur_declaration_form]

  read_inputs(file_name).each do |row|
    if row == ''
      cur_declaration_form = DeclarationForm.new
      declaration_forms << cur_declaration_form
      next
    end

    cur_declaration_form.responses << row
  end

  declaration_forms
end
