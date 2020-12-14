module Y2020
  class Day3
    include FileName
    include TwoDimensions

    TREE = '#'.freeze

    def initialize(file: nil, file_ext: nil)
      @data = load_data(file_name(file: file, file_ext: file_ext))
    end

    def part1
      t = 0
      y = 0
      x = 0

      while
        x += 3
        y += 1

        break if y >= height

        x = (x % width) if x >= width

        t += 1 if Day3::TREE == @data[y][x]
      end

      t
    end

    def part2
      t = []

      [[1,1],[3,1],[5,1],[7,1],[1,2]].each do |x_n, y_n|
        y  = 0
        x  = 0
        tn = 0

        while
          x += x_n
          y += y_n

          break if y >= height

          x = (x % width) if x >= width

          tn += 1 if Day3::TREE == @data[y][x]
        end

        t << tn
      end

      t.reduce(&:*)
    end
  end
end
