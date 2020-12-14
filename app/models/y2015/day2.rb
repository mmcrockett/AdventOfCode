module Y2015
  class Day2
    include FileName

    def initialize(file: nil, file_ext: nil)
      @data = load_data(file_name(file: file, file_ext: file_ext))
    end

    def load_data(file)
      File.open(file).each_line.map(&:chomp).map {|l| l.split('x') }
    end

    def part1
      total = 0

      @data.each do |dimensions|
        smallest = nil
        area     = 0

        dimensions.combination(2).each do |a, b|
          side = a.to_i * b.to_i
          area += side
          smallest = side if smallest.nil? || side < smallest
        end

        total += 2 * area + smallest
      end

      total
    end

    def part2
      total = 0

      @data.each do |dimensions|
        sorted = dimensions.map(&:to_i).sort

        total += 2 * (sorted[0] + sorted[1]) + sorted.reduce(&:*)
      end

      total
    end
  end
end
