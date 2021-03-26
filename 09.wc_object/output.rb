# frozen_string_literal: true

class Output
  def self.wc
    $stdin.stat.mode.to_s(8)[0] == '1' ? with_stdin : without_stdin
  end

  def self.with_stdin
    file = Stdin.new($stdin.readlines)
    print_number(file.lines)
    unless ARGV.include?('-l')
      print_number(file.words)
      print_number(file.bytes)
    end
    print "\n"
  end

  def self.without_stdin
    file_list = push_file_to_list
    file_list.each do |file|
      print_number(file.lines)
      unless ARGV.include?('-l')
        print_number(file.words)
        print_number(file.bytes)
      end
      print_last_text(file.name)
    end
    total(file_list) if should_show_total?(file_list)
  end

  def self.should_show_total?(file_list)
    file_list.size >= 2
  end

  def self.push_file_to_list
    file_list = []
    Find.find('.') do |f|
      file = f.slice(2..-1)
      file_list << File.new(file) if target?(file)
    end
    exit if file_list.empty?
    file_list
  end

  def self.target?(file)
    ARGV.include?(file)
  end

  def self.total(file_list)
    total = Calculation.total(file_list)
    total.each_value do |value|
      print_number(value)
      break if ARGV.include?('-l')
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
