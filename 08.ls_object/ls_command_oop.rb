# frozen_string_literal: false

require 'find'
require 'pathname'
require 'etc'
require 'date'

class File
  attr_reader :mode, :permission, :nlink, :uid, :gid, :size, :month, :day, :hour, :minute, :name

  def initialize(file)
    stat = Pathname(file).stat
    @mode = stat.mode
    @permission = display_permission(file)
    @nlink = stat.nlink
    @uid = Etc.getpwuid(stat.uid).name
    @gid = Etc.getgrgid(stat.gid).name
    @size = stat.size
    @month = stat.mtime.month
    @day = stat.mtime.day
    @hour = stat.mtime.hour
    @minute = stat.mtime.min
    @name = file
  end
end

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
  regex = /.*\/+.*/
  Find.find('.') do |f|
    if f == '.'
      file_list << f
      next
    end
    unless f.slice(2..-1).match?(regex)
      file_list << f.slice(2..-1)
    end
  end
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
  result_list = push_file_that_matches_regular_expression(file_list, regex)
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

def output_when_have_l_option(file_list, regex)
  result_list = push_file_that_matches_regular_expression(file_list, regex)
  word_max_length = Calculation.calculate_word_max_length(result_list)
  puts "total #{Calculation.calculate_total(result_list)}"
  result_list.each do |f|
    file = File.new(f)
    print "#{file.mode.to_s(8).slice(0) == '1' ? '-' : 'd'}#{file.permission}  "
    print "#{file.nlink.to_s.rjust(word_max_length[:max_nlink])} "
    print "#{file.uid.to_s.rjust(word_max_length[:max_uid_name])}  "
    print "#{file.gid.to_s.rjust(word_max_length[:max_gid_name])}  "
    print "#{file.size.to_s.rjust(word_max_length[:max_size])} "
    print "#{file.month.to_s.rjust(2, ' ')} #{file.day.to_s.rjust(2, ' ')} "
    print "#{file.hour.to_s.rjust(2, '0')}:#{file.minute.to_s.rjust(2, '0')} #{file.name}\n"
  end
end

def push_file_that_matches_regular_expression(file_list, regex)
  file_list.select { |file| file.match?(regex) }
end

class Calculation
  def self.calculate_word_max_length(result_list)
    word_max_length = {}
    word_max_length[:max_nlink] = Pathname(result_list.max_by { |file| Pathname(file).stat.nlink.to_s.size }).stat.nlink.to_s.size
    word_max_length[:max_uid_name] = Etc.getpwuid(Pathname(result_list.max_by { |file| Etc.getpwuid(Pathname(file).stat.uid).name.to_s.size }).stat.uid).name.size
    word_max_length[:max_gid_name] = Etc.getgrgid(Pathname(result_list.max_by { |file| Etc.getgrgid(Pathname(file).stat.gid).name.to_s.size }).stat.gid).name.size
    word_max_length[:max_size] = Pathname(result_list.max_by { |file| Pathname(file).stat.size.to_s.size }).stat.size.to_s.size
    word_max_length
  end

  def self.calculate_total(result_list)
    enqueue_file = []
    result_list.each { |f| enqueue_file << f if /^[^.]/.match?(f) }
    file_count = enqueue_file.inject(0) { |result, f| result + Pathname(f).stat.size }
    file_count / 512
    # TO DO file_countの値を正しく表示する
  end
end

output
