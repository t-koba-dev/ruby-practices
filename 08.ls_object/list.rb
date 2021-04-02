# frozen_string_literal: true

class List
  def self.push_file_to_list
    file_list = []
    Find.find('.') do |f|
      file_list << Filedata.new(f)
    end
    Find.find('..') do |f|
      file_list << Filedata.new(f)
      Find.prune
    end
    file_list.sort_by!(&:name)
  end
end
