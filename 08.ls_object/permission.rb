# frozen_string_literal: false

class Permission
  attr_reader :permission

  def initialize(file_name)
    @permission = Pathname(file_name).stat.mode.to_s(8).slice(-3..-1)
  end

  def display
    @permission.chars.inject('') { |result, str| result + encode_permission(str) }
  end

  private

  def encode_permission(str)
    permission_number = str.to_i

    case permission_number
    when 0
      '---'
    when 1
      '--x'
    when 2
      '-w-'
    when 3
      '-wx'
    when 4
      'r--'
    when 5
      'r-x'
    when 6
      'rw-'
    when 7
      'rwx'
    end
  end
end
