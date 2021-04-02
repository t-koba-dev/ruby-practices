# frozen_string_literal: true

class Calculation
  def self.calculate_word_max_length(result_list)
    {
      max_nlink: (result_list.max_by { |file| file.nlink.to_s.size }).nlink.to_s.size,
      max_uid_name: (result_list.max_by { |file| file.uid.size }).uid.size,
      max_gid_name: (result_list.max_by { |file| file.gid.size }).gid.size,
      max_size: (result_list.max_by { |file| file.size.to_s.size }).size.to_s.size
    }
  end

  def self.calculate_total(result_list)
    enqueue_file = []
    result_list.each { |f| enqueue_file << f if /\.\/[^.]/.match?(f.name) }
    enqueue_file.inject(0) { |result, f| result + 8 * (f.size / 4096 + 1) }
  end
end
