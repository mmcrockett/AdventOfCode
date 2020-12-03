module TwoDimensions
  extend ActiveSupport::Concern

  def load_data(file)
    File.open(file).each_line.map(&:chomp)
  end

  def width
    @width ||= @data.first.size
  end

  def height
    @height ||= @data.size
  end
end
