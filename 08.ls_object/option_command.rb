# frozen_string_literal: true

class OptionCommand
  def self.output_when_have_not_l_option(file_list, regex_to_exclude_hidden_files)
    result_list = RegularExpression.push_file_that_matches_regular_expression(file_list, regex_to_exclude_hidden_files)
    file_name_word_max_length = (result_list.max_by { |file| file.name.size }).name.size
    quotient, remainder = result_list.size.divmod(3)
    quotient += 1 if remainder != 0
    result_hash = result_list.group_by.with_index { |_file, i| i % quotient }
    result_hash.each_value do |files|
      files.each do |file|
        print file.name.ljust(file_name_word_max_length + 2)
      end
      print "\n"
    end
  end

  def self.output_when_have_l_option(file_list, regex_to_exclude_hidden_files)
    result_list = RegularExpression.push_file_that_matches_regular_expression(file_list, regex_to_exclude_hidden_files)
    word_max_length = Calculation.calculate_word_max_length(result_list)
    puts "total #{Calculation.calculate_total(result_list)}"
    result_list.each do |file|
      print file.output_permission
      print file.output_nlink(word_max_length[:nlink])
      print file.output_uid(word_max_length[:uid])
      print file.output_gid(word_max_length[:gid])
      print file.output_size(word_max_length[:size])
      print file.output_month_and_day
      print file.output_hour_and_minute
      print file.output_name
    end
  end

  def self.output_when_have_r_option(file_list)
    file_list.reverse
  end
end
