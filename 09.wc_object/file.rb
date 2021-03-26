# frozen_string_literal: true

class File
  attr_reader :lines, :words, :bytes, :name

  def initialize(file)
    @lines = IO.readlines(file).size
    @words = IO.read(file).split(' ').size
    @bytes = IO.read(file).size
    @name = file
  end
end
