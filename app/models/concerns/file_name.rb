module FileName
  extend ActiveSupport::Concern

  def file_name(file: nil, file_ext: nil)
    fn = file || "#{self.class.to_s.underscore}#{file_ext}.txt"

    Rails.root.join("test/fixtures/files/#{fn}")
  end

  def load_data(file)
    File.open(file).each_line.map(&:chomp)
  end
end
