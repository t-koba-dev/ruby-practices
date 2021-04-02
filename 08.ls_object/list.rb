# frozen_string_literal: true

class List
  def self.push_file_to_list
    file_list = []
    regex = %r{/.*/+.*/}
    Find.find('.') do |f|
      if f == '.'
        file_list << Filedata.new(f)
      else
        file_list << Filedata.new(f.slice(2..-1)) unless f.slice(2..-1).match?(regex)
      end
    end
    Find.find('..') do |f|
      file_list << Filedata.new(f)
      Find.prune
    end
    file_list.sort_by!(&:name)
  end
end
