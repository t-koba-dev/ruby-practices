# frozen_string_literal: true

class Calculation
  def self.calculate(file_list)
    output_file_list = Hash.new { |hash, key| hash[key] = {} }
    file_list.each do |f|
      output_file_list[:"#{f}"][:lines] = IO.readlines(f).size
      unless ARGV.include?('-l')
        output_file_list[:"#{f}"][:words] = IO.read(f).split(' ').size
        output_file_list[:"#{f}"][:size] = IO.read(f).size
      end
    end
    output_file_list
  end
end
