# frozen_string_literal: true

class Output
  def self.wc
    $stdin.stat.mode.to_s(8)[0] == '1' ? with_stdin : without_stdin
  end

  private

  def self.with_stdin
    f = $stdin.readlines
    print f.size.to_s.rjust(8)
    unless ARGV.include?('-l')
      print f.join(' ').split(' ').size.to_s.rjust(8)
      print f.join.size.to_s.rjust(8)
    end
    print "\n"
  end
  
  def self.without_stdin
    file_list = push_file_to_list
    file_list.each do |file|
      print_number(file.lines)
      print_number(file.words)
      print_number(file.bytes)
      print_last_text(file.name)
    end
    total(file_list) if file_list.size >= 2
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

  def self.total(file_list)
    total = Calculation.total(file_list)
    total.each_value do |value|
      print_number(value)
    end
    print_last_text
  end

  def self.print_number(text)
    print text.to_s.rjust(8)
  end

  def self.print_last_text(text = 'total')
    print " #{text}\n"
  end
end
