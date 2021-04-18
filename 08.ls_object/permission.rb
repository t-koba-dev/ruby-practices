# frozen_string_literal: false

class Permission
  def self.display_permission(file)
    Pathname(file).stat.mode.to_s(8).slice(-3..-1).chars.inject('') { |result, str| result + encode_permission(str) }
  end

  def self.encode_permission(str)
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
