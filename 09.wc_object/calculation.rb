# frozen_string_literal: true

class Calculation
  def self.total(file_list)
    {
      lines: file_list.inject(0) { |result, file| result + file.lines },
      words: file_list.inject(0) { |result, file| result + file.words },
      bytes: file_list.inject(0) { |result, file| result + file.bytes }
    }
  end
end
