# frozen_string_literal: false

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
