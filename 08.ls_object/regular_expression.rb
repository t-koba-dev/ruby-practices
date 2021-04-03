# frozen_string_literal: false

class RegularExpression
  def self.push_file_that_matches_regular_expression(file_list, regex_to_exclude_hidden_files)
    file_list.select { |file| file.name.match?(regex_to_exclude_hidden_files) }
  end
end
