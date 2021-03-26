# frozen_string_literal: true

class Stdin
  attr_reader :lines, :words, :bytes

  def initialize(file)
    @lines = file.size
    @words = file.join(' ').split(' ').size
    @bytes = file.join.size
  end
end
