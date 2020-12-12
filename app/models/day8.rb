class Day8
  # 1146 too low
  include FileName

  def initialize(file: nil, file_ext: nil)
    @raw_data = load_data(file_name(file: file, file_ext: file_ext))
  end

  def part1
    total_size  = @raw_data.map(&:chars).flatten.size
    string_size = @raw_data.map do |line|
      line.delete_prefix('"').delete_suffix('"').gsub('\"', '"').gsub(/\\x(\d|a|b|c|d|e|f){2}/, 'X').gsub('\\\\', '\\').chars
    end.flatten.size

    total_size - string_size
  end

  def part2
    total_size  = @raw_data.map(&:chars).flatten.size

    encoded_size = @raw_data.map do |line|
      line.chars.map {|char| char.in?(['\\', '"']) ? 2 : 1 }.sum + 2
    end.sum

    encoded_size - total_size
  end
end
