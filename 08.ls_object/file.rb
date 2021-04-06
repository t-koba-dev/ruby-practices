# frozen_string_literal: true

class Filedata
  attr_reader :mode, :permission, :nlink, :uid, :gid, :size, :month, :day, :hour, :minute, :name

  def self.output
    file_list = List.push_file_to_list
    file_list = OptionCommand.output_when_have_r_option(file_list) if ARGV[0]&.include?('r')
    regex_to_exclude_hidden_files = (ARGV[0]&.include?('a') ? // : /\A[^\.]/)
    if ARGV[0]&.include?('l')
      OptionCommand.output_when_have_l_option(file_list, regex_to_exclude_hidden_files)
    else
      OptionCommand.output_when_have_not_l_option(file_list, regex_to_exclude_hidden_files)
    end
  end

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
    if file == '.' || file == '..'
      @name = file
    else
      @name = file.slice(2..-1)
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

end
