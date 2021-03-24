# frozen_string_literal: true

class OptionCommand
  def self.output_when_have_not_l_option(file_list, regex)
    result_list = RegularExpression.push_file_that_matches_regular_expression(file_list, regex)
    file_name_word_max_length = result_list.max_by(&:size).size
    number = result_list.size.divmod(3)
    number[0] += 1 if number[1] != 0
    result_hash = result_list.group_by.with_index { |_file, i| i % number[0] }
    result_hash.each_value do |array|
      array.each do |file|
        print file.ljust(file_name_word_max_length + 2)
      end
      print "\n"
    end
  end

  def self.output_when_have_l_option(file_list, regex)
    result_list = RegularExpression.push_file_that_matches_regular_expression(file_list, regex)
    word_max_length = Calculation.calculate_word_max_length(result_list)
    puts "total #{Calculation.calculate_total(result_list)}"
    result_list.each do |f|
      file = File.new(f)
      print file.output_permission
      print file.output_nlink(word_max_length[:max_nlink])
      print file.output_uid(word_max_length[:max_uid_name])
      print file.output_gid(word_max_length[:max_gid_name])
      print file.output_size(word_max_length[:max_size])
      print file.output_month_and_day
      print file.output_hour_and_minute
      print file.output_name
    end
  end
end
