class ElfImageDecoder
  attr_reader :width, :height, :pixels

  def initialize(data, width:, height:)
    @pixels = parse_pixels(data, width, height)
    @width  = width
    @height = height
  end

  def color(x, y)
    @pixels.each do |pixel|
      color = pixel[y * width + x]

      return ' ' if '0' == color
      return 'X' if '1' == color
    end
  end

  private
  def parse_pixels(d, w, h)
    index = 0
    result = []
    size  = (w * h).freeze

    while (index < d.size)
      result << d.slice(index, size)

      index += size
    end

    return result.freeze
  end
end
