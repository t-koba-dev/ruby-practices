# frozen_string_literal: false

class FileData
  attr_reader :mode, :permission, :nlink, :uid, :gid, :size, :month, :day, :hour, :minute, :name

  def self.output
    file_list = build_file_list
    file_list = file_list.reverse if ARGV[0]&.include?('r')
    unless ARGV[0]&.include?('a')
      filtering_regex = /\A[^.]/
      file_list = file_list.select { |file| file.name.match?(filtering_regex) }
    end
    if ARGV[0]&.include?('l')
      output_with_l_option(file_list)
    else
      output_without_l_option(file_list)
    end
  end

  def self.output_without_l_option(file_list)
    file_name_word_max_length = (file_list.max_by { |file| file.name.size }).name.size
    quotient, remainder = file_list.size.divmod(3)
    quotient += 1 if remainder != 0
    result_hash = file_list.group_by.with_index { |_file, i| i % quotient }
    result_hash.each_value do |files|
      files.each do |file|
        print file.name.ljust(file_name_word_max_length + 2)
      end
      print "\n"
    end
  end

  def self.output_with_l_option(file_list)
    word_max_length = FileData.calculate_word_max_length(file_list)
    puts "total #{FileData.calculate_total(file_list)}"
    file_list.each do |file|
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

  def self.build_file_list
    file_list = []
    Find.find('.') do |file_path|
      file_list << FileData.new(file_path)
    end
    Find.find('..') do |file_path|
      file_list << FileData.new(file_path)
      Find.prune
    end
    file_list.sort_by!(&:name)
  end

  def self.calculate_word_max_length(file_list)
    max_length = Hash.new(0)

    file_list.each do |file|
      max_length[:nlink] = file.nlink.to_s.size if max_length[:nlink] < file.nlink.to_s.size
      max_length[:uid] = file.uid.size if max_length[:uid] < file.uid.size
      max_length[:gid] = file.gid.size if max_length[:gid] < file.gid.size
      max_length[:size] = file.size.to_s.size if max_length[:size] < file.size.to_s.size
    end

    max_length
  end

  def self.calculate_total(file_list)
    filtering_regex = /\A[^.]/
    enqueue_file = []
    file_list.each { |f| enqueue_file << f if f.name.match?(filtering_regex) }
    enqueue_file.inject(0) { |result, f| result + File.stat(f.name).blocks }
  end

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
    @name = if ['.', '..'].include?(file)
              file
            else
              file.slice(2..-1)
            end
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

  def display_permission(file)
    permission = fetch_permission(file)
    permission.chars.inject('') { |result, str| result + encode_permission(str) }
  end

  def fetch_permission(file)
    Pathname(file).stat.mode.to_s(8).slice(-3..-1)
  end

  def encode_permission(str)
    permission = '---'
    permission_number = str.to_i
    if permission_number / 4 == 1
      permission[0] = 'r'
      permission_number -= 4
    end

    if permission_number >= 2
      permission[1] = 'w'
      permission_number -= 2
    end

    permission[2] = 'x' if permission_number == 1

    permission
  end
end