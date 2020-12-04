require_relative 'read_inputs'

class Passport
  attr_accessor(
    :birth_year,
    :issue_year,
    :exp_year,
    :height,
    :hair_color,
    :eye_color,
    :passport_id,
    :country_id,
  )

  def valid?
    !!(birth_year &&
      issue_year &&
      exp_year &&
      height &&
      hair_color &&
      eye_color &&
      passport_id
    )
  end
end

def read_passports(file_name)
  inputs = read_inputs(file_name)

  passports = []
  cur_passport = Passport.new
  inputs.each do |line|
    if line == ''
      passports << cur_passport
      cur_passport = Passport.new
      next
    end

    attr_pairs = line.split(' ').map! { |pair| pair.split(':') }
    attr_pairs.each do |tuple|
      case tuple[0]
      when 'byr'
        cur_passport.birth_year = tuple[1]
      when 'iyr'
        cur_passport.issue_year = tuple[1]
      when 'eyr'
        cur_passport.exp_year = tuple[1]
      when 'hgt'
        cur_passport.height = tuple[1]
      when 'hcl'
        cur_passport.hair_color = tuple[1]
      when 'ecl'
        cur_passport.eye_color = tuple[1]
      when 'pid'
        cur_passport.passport_id = tuple[1]
      when 'cid'
        cur_passport.country_id = tuple[1]
      else
        raise "Unexpect key found #{tuple[0]} in line #{line}"
      end
    end
  end

  passports << cur_passport

  passports
end
