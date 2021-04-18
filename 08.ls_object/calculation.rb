# frozen_string_literal: true

class Calculation
  def self.calculate_word_max_length(result_list)
    max_length = Hash.new(0)

    result_list.each do |file|
      max_length[:nlink] = file.nlink.to_s.size if max_length[:nlink] < file.nlink.to_s.size
      max_length[:uid] = file.uid.size if max_length[:uid] < file.uid.size
      max_length[:gid] = file.gid.size if max_length[:gid] < file.gid.size
      max_length[:size] = file.size.to_s.size if max_length[:size] < file.size.to_s.size
    end

    max_length
  end

  def self.calculate_total(result_list)
    regex_to_exclude_hidden_files = /\A[^.]/
    enqueue_file = []
    result_list.each { |f| enqueue_file << f if f.name.match?(regex_to_exclude_hidden_files) }
    enqueue_file.inject(0) { |result, f| result + File.stat(f.name).blocks }
  end
end
