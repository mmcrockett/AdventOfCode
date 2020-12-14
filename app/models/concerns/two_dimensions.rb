module TwoDimensions
  extend ActiveSupport::Concern

  def width
    @width ||= @data.first.size
  end

  def height
    @height ||= @data.size
  end
end
