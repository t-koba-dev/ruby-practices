# frozen_string_literal: false

class FileData
  attr_reader :mode, :permission, :nlink, :uid, :gid, :size, :month, :day, :hour, :minute, :name

  Option = ARGV[0]

  def self.output
    file_list = build_file_list
    file_list = file_list.reverse if Option&.include?('r')
    if Option&.include?('l')
      output_with_l_option(file_list)
    else
      output_without_l_option(file_list)
    end
  end

  def self.output_without_l_option(file_list)
    file_name_word_max_length = file_list.max_by { |file| file.name.size }.name.size
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
    file_calc = Calculation.new(file_list)
    puts "total #{file_list.sum { |f| File.stat(f.name).blocks }}"
    file_list.each do |file|
      print "#{file.mode.to_s(8).slice(0) == '1' ? '-' : 'd'}#{file.permission.display}  "
      print "#{file.nlink.to_s.rjust(file_calc.max_length_nlink)} "
      print "#{file.uid.to_s.ljust(file_calc.max_length_uid)}  "
      print "#{file.gid.to_s.ljust(file_calc.max_length_gid)}  "
      print "#{file.size.to_s.rjust(file_calc.max_length_size)} "
      print "#{file.month.to_s.rjust(2, ' ')} #{file.day.to_s.rjust(2, ' ')} "
      print "#{file.hour.to_s.rjust(2, '0')}:#{file.minute.to_s.rjust(2, '0')} "
      puts file.name
    end
  end

  def self.build_file_list
    file_names = if Option&.include?('a')
                         Dir.glob('*', File::FNM_DOTMATCH)
                       else
                         Dir.glob('*')
                       end
    file_names.map { |file_name| FileData.new(file_name) }
  end

  def initialize(file)
    stat = Pathname(file).stat
    @mode = stat.mode
    @permission = Permission.new(file)
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
