# frozen_string_literal: true

class Output
  def self.output_with_stdin
    f = $stdin.readlines
    print f.size.to_s.rjust(8)
    unless ARGV.include?('-l')
      print f.join(' ').split(' ').size.to_s.rjust(8)
      print f.join.size.to_s.rjust(8)
    end
    print "\n"
  end
  
  def self.output_without_stdin
    file_list = push_file_to_list
    file_list.each do |file|
      print file.lines.to_s.rjust(8)
      print file.words.to_s.rjust(8)
      print file.bytes.to_s.rjust(8)
      print " #{file.name}\n"
    end
    output_total(file_list) if file_list.size >= 2
  end
  
  def self.push_file_to_list
    file_list = []
    Find.find('.') do |file|
      f = file.slice(2..-1)
      file_list << File.new(f) if ARGV.include?(f)
    end
    exit if file_list.empty?
    file_list
  end

  def self.output_total(file_list)
    total = {
      lines: file_list.inject(0) { |result, file| result +file.lines },
      words: file_list.inject(0) { |result, file| result +file.words },
      bytes: file_list.inject(0) { |result, file| result +file.bytes }
    }
    total.each_value do |value|
      print value.to_s.rjust(8)
    end
    print " total\n"
  end
end
