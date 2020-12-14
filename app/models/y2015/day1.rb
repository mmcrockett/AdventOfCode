module Y2015
  class Day1
    #1769 too low
    include FileName

    def initialize(file: nil, file_ext: nil)
      @data = load_data(file_name(file: file, file_ext: file_ext))
    end

    def load_data(file)
      File.open(file).each_line.map(&:chomp)
    end

    def part1
      @data.map {|l| l.chars.map {|v| '(' == v ? 1 : -1 }.sum }
    end

    def part2
      floor = 0

      @data.first.chars.each_with_index do |v, i|
        floor += '(' == v ? 1 : -1

        return (i + 1) if floor < 0
      end

      floor
    end
  end
end
