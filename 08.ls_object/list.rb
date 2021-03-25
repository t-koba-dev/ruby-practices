# frozen_string_literal: true

class List
  def self.push_file_to_list
    file_list = []
    regex = %r{/.*/+.*/}
    Find.find('.') do |f|
      if f == '.'
        file_list << File.new(f)
        next
      end
      file_list << File.new(f.slice(2..-1)) unless f.slice(2..-1).match?(regex)
    end
    Find.find('..') do |f|
      file_list << File.new(f)
      Find.prune
    end
    file_list.sort_by!(&:name)
  end
end
