# frozen_string_literal: false

class Calculation
  attr_reader :file_data_list

  def initialize(file_data_list)
    @file_data_list = file_data_list
  end

  def max_length_nlink
    @file_data_list.map(&:nlink).max.to_s.size
  end

  def max_length_uid
    @file_data_list.map(&:uid).max.size
  end

  def max_length_gid
    @file_data_list.map(&:gid).max.size
  end

  def max_length_size
    @file_data_list.map(&:size).max.to_s.size
  end
end
