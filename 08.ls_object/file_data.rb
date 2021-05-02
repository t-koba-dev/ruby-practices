# frozen_string_literal: false

class FileData
  attr_reader :mode, :permission, :nlink, :uid, :gid, :size, :month, :day, :hour, :minute, :name

  Option = ARGV[0]

  def self.output
    file_data_list = build_file_data_list
    file_data_list = file_data_list.reverse if Option&.include?('r')
    if Option&.include?('l')
      output_with_l_option(file_data_list)
    else
      output_without_l_option(file_data_list)
    end
  end

  def self.output_without_l_option(file_data_list)
    max_file_name_length = file_data_list.max_by { |file_data| file_data.name.size }.name.size
    quotient, remainder = file_data_list.size.divmod(3)
    quotient += 1 if remainder != 0
    grouped_file_data_list = file_data_list.group_by.with_index { |_file, i| i % quotient }
    grouped_file_data_list.each_value do |file_data_group|
      file_data_group.each do |file_data|
        print file_data.name.ljust(max_file_name_length + 2)
      end
      print "\n"
    end
  end

  def self.output_with_l_option(file_data_list)
    puts "total #{file_data_list.sum { |f| File.stat(f.name).blocks }}"
    file_calc = Calculation.new(file_data_list)
    file_data_list.each do |file_data|
      print "#{file_data.display_file_type}#{file_data.permission.display}  "
      print "#{file_data.nlink.to_s.rjust(file_calc.max_length_nlink)} "
      print "#{file_data.uid.to_s.ljust(file_calc.max_length_uid)}  "
      print "#{file_data.gid.to_s.ljust(file_calc.max_length_gid)}  "
      print "#{file_data.size.to_s.rjust(file_calc.max_length_size)} "
      print "#{file_data.month.to_s.rjust(2, ' ')} #{file_data.day.to_s.rjust(2, ' ')} "
      print "#{file_data.hour.to_s.rjust(2, '0')}:#{file_data.minute.to_s.rjust(2, '0')} "
      puts file_data.name
    end
  end

  def self.build_file_data_list
    file_names = if Option&.include?('a')
                         Dir.glob('*', File::FNM_DOTMATCH)
                       else
                         Dir.glob('*')
                       end
    file_names.map { |file_name| FileData.new(file_name) }
  end

  def initialize(file_name)
    stat = Pathname(file_name).stat
    @mode = stat.mode
    @permission = Permission.new(file_name)
    @nlink = stat.nlink
    @uid = Etc.getpwuid(stat.uid).name
    @gid = Etc.getgrgid(stat.gid).name
    @size = stat.size
    @month = stat.mtime.month
    @day = stat.mtime.day
    @hour = stat.mtime.hour
    @minute = stat.mtime.min
    @name = file_name
  end

  def display_file_type
    mode.to_s(8).slice(0) == '1' ? '-' : 'd'
  end
end
