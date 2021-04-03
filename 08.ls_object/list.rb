# frozen_string_literal: true

class List
  def self.push_file_to_list
    file_list = []
    Find.find('.') do |file_pass|
      file_list << Filedata.new(file_pass)
    end
    Find.find('..') do |file_pass|
      file_list << Filedata.new(file_pass)
      Find.prune
    end
    file_list.sort_by!(&:name)
  end
end
