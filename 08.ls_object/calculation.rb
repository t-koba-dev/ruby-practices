# frozen_string_literal: true

class Calculation
  def self.calculate_word_max_length(result_list)
    {
      max_nlink: Pathname(result_list.max_by { |file| Pathname(file).stat.nlink.to_s.size }).stat.nlink.to_s.size,
      max_uid_name: Etc.getpwuid(Pathname(result_list.max_by { |file| Etc.getpwuid(Pathname(file).stat.uid).name.to_s.size }).stat.uid).name.size,
      max_gid_name: Etc.getgrgid(Pathname(result_list.max_by { |file| Etc.getgrgid(Pathname(file).stat.gid).name.to_s.size }).stat.gid).name.size,
      max_size: Pathname(result_list.max_by { |file| Pathname(file).stat.size.to_s.size }).stat.size.to_s.size
    }
  end

  def self.calculate_total(result_list)
    enqueue_file = []
    result_list.each { |f| enqueue_file << f if /^[^.]/.match?(f) }
    enqueue_file.inject(0) { |result, f| result + 8 * (Pathname(f).stat.size / 4096 + 1) }
  end
end
