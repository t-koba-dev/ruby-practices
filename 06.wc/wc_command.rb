# frozen_string_literal: true

require 'find'

def output_with_stdin
  f = $stdin.readlines
  print f.size.to_s.rjust(8)
  unless ARGV.include?('-l')
    print f.join(' ').split(' ').size.to_s.rjust(8)
    print f.join.size.to_s.rjust(8)
  end
  print "\n"
end

def output_without_stdin
  file_list = push_file_to_list
  output_file_list = calculate(file_list)
  output_file_list.each_pair do |file_name, file|
    file.each_value do |value|
      print value.to_s.rjust(8)
    end
    print " #{file_name}\n"
  end
  output_total(file_list) if file_list.size >= 2
end

def push_file_to_list
  file_list = []
  Find.find('.') do |file|
    f = file.slice(2..-1)
    file_list << f if ARGV.include?(f)
  end

  exit if file_list.empty?
  file_list
end

def calculate(file_list)
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

def output_total(file_list)
  total = Hash.new(0)
  file_list.each do |f|
    total[:lines] += IO.readlines(f).size
    unless ARGV.include?('-l')
      total[:words] += IO.read(f).split(' ').size
      total[:size] += IO.read(f).size
    end
  end
  total.each_value do |value|
    print value.to_s.rjust(8)
  end
  print " total\n"
end

if $stdin.stat.mode.to_s(8)[0] == '1'
  output_with_stdin
else
  output_without_stdin
end
