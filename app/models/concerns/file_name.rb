module FileName
  extend ActiveSupport::Concern

  def file_name(file: nil, file_ext: nil)
    file_ext ||= :txt
    prefix = "#{self.class.to_s.underscore}"
    fn = "#{prefix}e" if file == :sample
    fn ||= file || "#{prefix}"

    Rails.root.join("test/fixtures/files/#{fn}.#{file_ext}")
  end

  def load_data(file)
    File.open(file).each_line.map(&:chomp)
  end
end
