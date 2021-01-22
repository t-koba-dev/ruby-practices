# frozen_string_literal: false

require 'find'
require 'pathname'
require 'etc'
require 'date'

def display_permission(file)
  Pathname(file).stat.mode.to_s(8).slice(-3..-1).chars.inject('') { |result, str| result + encode_permission(str) }
end

def encode_permission(str)
  permission = '---'
  str = str.to_i
  if str / 4 == 1
    permission[0] = 'r'
    str -= 4
  end
  permission[1] = 'w' if str >= 2
  permission[2] = 'x' if str.odd?
  permission
end

def push_file_to_list
  file_list = []
  Find.find('.') { |f| file_list << (f == '.' ? f : f.slice(2..-1)) }
  Find.find('..') do |f|
    file_list << f
    Find.prune
  end
  file_list.sort
end

def output
  file_list = push_file_to_list
  file_list = file_list.reverse if ARGV[0]&.include?('r')
  regex = (ARGV[0]&.include?('a') ? // : /^[^.]/)
  if ARGV[0]&.include?('l')
    output_when_have_l_option(file_list, regex)
  else
    output_when_have_not_l_option(file_list, regex)
  end
end

def output_when_have_not_l_option(file_list, regex)
  file_list_no_l = []
  file_list.each { |f| file_list_no_l << f if f&.match?(regex) }
  file_name_word_max_length = 0
  file_list_no_l.each do |f|
    file_name_word_max_length = f.size if f.size > file_name_word_max_length
  end
  number = file_list_no_l.size.divmod(3)
  number[0] += 1 if number[1] != 0
  result_hash = file_list_no_l.group_by.with_index { |_file, i| i % number[0] }
  result_hash.each_value do |array|
    array.each do |file|
      print file.ljust(file_name_word_max_length + 2)
    end
    print "\n"
  end
end

def output_when_have_l_option(file_list, regex)
  file_list_l = []
  file_list.each { |f| file_list_l << f if f&.match?(regex) }
  word_max_length = calculate_word_max_length(file_list_l)
  puts "total #{calculate_total(file_list_l)}"
  file_list_l.each do |f|
    stat = Pathname(f).stat
    print "#{stat.mode.to_s(8).slice(0) == '1' ? '-' : 'd'}#{display_permission(f)}#{f == '..' ? '@ ' : '  '}#{stat.nlink.to_s.rjust(word_max_length[:max_nlink])} "
    print "#{Etc.getpwuid(stat.uid).name.to_s.rjust(word_max_length[:max_uid_name])}  #{Etc.getgrgid(stat.gid).name.to_s.rjust(word_max_length[:max_gid_name])}  "
    print "#{stat.size.to_s.rjust(word_max_length[:max_size])} "
    print "#{stat.mtime.month.to_s.rjust(2,
                                         ' ')} #{stat.mtime.day.to_s.rjust(2,
                                                                           ' ')} #{stat.mtime.hour.to_s.rjust(2,
                                                                                                              '0')}:#{stat.mtime.min.to_s.rjust(2, '0')} #{f}\n"
  end
  exit
end

def calculate_word_max_length(file_list_l)
  word_max_length = {}
  word_max_length.default = 0
  file_list_l.map do |file|
    stat = Pathname(file).stat
    word_max_length[:max_nlink] = stat.nlink.to_s.size if word_max_length[:max_nlink] < stat.nlink.to_s.size
    word_max_length[:max_uid_name] = Etc.getpwuid(stat.uid).name.to_s.size if word_max_length[:max_uid_name] < Etc.getpwuid(stat.uid).name.to_s.size
    word_max_length[:max_gid_name] = Etc.getgrgid(stat.gid).name.to_s.size if word_max_length[:max_gid_name] < Etc.getgrgid(stat.gid).name.to_s.size
    word_max_length[:max_size] = stat.size.to_s.size if word_max_length[:max_size] < stat.size.to_s.size
  end
  word_max_length
end

def calculate_total(file_list_l)
  enqueue_file = []
  file_list_l.each { |f| enqueue_file << f if /^[^.]/.match?(f) }
  file_count = enqueue_file.inject(0) { |result, f| result + Pathname(f).stat.size }
  total = file_count / 512
  total += 1 unless (file_count % 512).zero?
end

ARGV[0]&.chars&.uniq&.join
output
