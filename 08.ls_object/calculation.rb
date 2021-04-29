# frozen_string_literal: false

class Calculation
  attr_reader :file_list

  def initialize(file_list)
    @file_list = file_list
  end

  def max_length_nlink
    @file_list.map(&:nlink).max.to_s.size
  end

  def max_length_uid
    @file_list.map(&:uid).max.size
  end

  def max_length_gid
    @file_list.map(&:gid).max.size
  end

  def max_length_size
    @file_list.map(&:size).max.to_s.size
  end
end
