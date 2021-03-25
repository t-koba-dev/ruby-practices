# frozen_string_literal: false

class RegularExpression
  def self.push_file_that_matches_regular_expression(file_list, regex)
    file_list.select { |file| file.name.match?(regex) }
  end
end
