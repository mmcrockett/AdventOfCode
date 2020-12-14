class Day5
  include FileName

  ROW_MAPPING = Array.new(128) {|t| format('%<v>07d', v: t.to_s(2)).gsub('0', 'F').gsub('1', 'B') }
  COL_MAPPING = Array.new(8) {|t| format('%<v>03d', v: t.to_s(2)).gsub('0', 'L').gsub('1', 'R') }

  def initialize(file: nil, file_ext: nil)
    @data = load_data(file_name(file: file, file_ext: file_ext))
  end

  def id(row: , col: )
    row * 8 + col
  end

  def load_data(file)
    File.open(file).each_line.map(&:chomp)
  end

  def part1
    @data.map do |value|
      id(row: ROW_MAPPING.index(value[0..6]), col: COL_MAPPING.index(value[7..9]))
    end
  end

  def part2
    sorted_ids = self.part1.sort

    (0..sorted_ids.size - 2).each do |i|
      return sorted_ids[i] + 1 if sorted_ids[i] + 2 == sorted_ids[i + 1]
    end
  end
end
