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
    @permission = Permission.display_permission(file)
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

  def output_permission
    "#{@mode.to_s(8).slice(0) == '1' ? '-' : 'd'}#{@permission}  "
  end

  def output_nlink(max_nlink)
    "#{@nlink.to_s.rjust(max_nlink)} "
  end

  def output_uid(max_uid_name)
    "#{@uid.to_s.rjust(max_uid_name)}  "
  end

  def output_gid(max_gid_name)
    "#{@gid.to_s.rjust(max_gid_name)}  "
  end

  def output_size(max_size)
    "#{@size.to_s.rjust(max_size)} "
  end

  def output_month_and_day
    "#{@month.to_s.rjust(2, ' ')} #{@day.to_s.rjust(2, ' ')} "
  end

  def output_hour_and_minute
    "#{@hour.to_s.rjust(2, '0')}:#{@minute.to_s.rjust(2, '0')} "
  end

  def output_name
    "#{@name}\n"
  end

  def self.output
    file_list = List.push_file_to_list
    file_list = file_list.reverse if ARGV[0]&.include?('r')
    regex = (ARGV[0]&.include?('a') ? // : /^[^.]/)
    if ARGV[0]&.include?('l')
      OptionCommand.output_when_have_l_option(file_list, regex)
    else
      OptionCommand.output_when_have_not_l_option(file_list, regex)
    end
  end
end

class Permission
  def self.display_permission(file)
    Pathname(file).stat.mode.to_s(8).slice(-3..-1).chars.inject('') { |result, str| result + encode_permission(str) }
  end

  def self.encode_permission(str)
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
end

class List
  def self.push_file_to_list
    file_list = []
    regex = %r{/.*/+.*/}
    Find.find('.') do |f|
      if f == '.'
        file_list << f
        next
      end
      file_list << f.slice(2..-1) unless f.slice(2..-1).match?(regex)
    end
    Find.find('..') do |f|
      file_list << f
      Find.prune
    end
    file_list.sort
  end
end

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

class RegularExpression
  def self.push_file_that_matches_regular_expression(file_list, regex)
    file_list.select { |file| file.match?(regex) }
  end
end

class Calculation
  def self.calculate_word_max_length(result_list)
    {
      max_nlink: Pathname(result_list.max_by { |file| Pathname(file).stat.nlink.to_s.size }).stat.nlink.to_s.size,
      max_uid_name: Etc.getpwuid(Pathname(result_list.max_by { |file| Etc.getpwuid(Pathname(file).stat.uid).name.to_s.size }).stat.uid).name.size,
      max_gid_name: Etc.getgrgid(Pathname(result_list.max_by { |file| Etc.getgrgid(Pathname(file).stat.gid).name.to_s.size }).stat.gid).name.size,
      max_size: Pathname(result_list.max_by { |file| Pathname(file).stat.size.to_s.size }).stat.size.to_s.size
    }
  end

  def self.calculate_total(result_list)
    enqueue_file = []
    result_list.each { |f| enqueue_file << f if /^[^.]/.match?(f) }
    enqueue_file.inject(0) { |result, f| result + 8 * (Pathname(f).stat.size / 4096 + 1) }
  end
end

File.output
