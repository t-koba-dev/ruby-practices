# frozen_string_literal: true

class Option
  def self.enqueue
    ARGV[0]&.split(',')
  end
end
