# frozen_string_literal: true

module Year2022
  class Day08 < Solution
    # @input is available if you need the raw data input
    # Call `data` to access either an array of the parsed data, or a single record for a 1-line input file
    #
    def visual(grid)
      grid.each do |row|
        row.each do |v|
          print(v)
        end
        puts ''
      end
    end

    def part_1
      li = data.size - 1
      result = Array.new(data.size) { Array.new(data.size, '?') }
      @debug = false

      data.size.times do |i|
        data.size.times do |j|
          v = data[i][j]
          result[i][j] = 'v' if 0 == i || 0 == j || li == i || li == j

          next if 'v' == result[i][j]

          result[i][j] = 'v' if (0..j - 1).all? { |k| v > data[i][k] } ||
                                (j + 1..li).all? { |k| v > data[i][k] } ||
                                (0..i - 1).all? { |k| v > data[k][j] } ||
                                (i + 1..li).all? { |k| v > data[k][j] }
        end
      end

      visual(result) if @debug
      result.sum { |rrow| rrow.count { |v| 'v' == v } }
    end

    def part_2
      li = data.size - 1
      result = Array.new(data.size) { Array.new(data.size, '?') }
      @debug = false

      data.size.times do |i|
        data.size.times do |j|
          v = data[i][j]
          scores = [
            scenic_score((0..j - 1).to_a.reverse.index { |k| v <= data[i][k] }, (0..j - 1)),
            scenic_score((j + 1..li).to_a.index { |k| v <= data[i][k] }, (j + 1..li)),
            scenic_score((0..i - 1).to_a.reverse.index { |k| v <= data[k][j] }, (0..i - 1)),
            scenic_score((i + 1..li).to_a.index { |k| v <= data[k][j] }, (i + 1..li))
          ]

          result[i][j] = scores.reduce(&:*)
        end
      end

      visual(result) if @debug

      result.flatten.max
    end

    private

    def scenic_score(r, a)
      return r + 1 if r

      a.to_a.size
    end

    # Processes each line of the input file and stores the result in the dataset
    def process_input(line)
      line.chars.map(&:to_i)
    end

    # Processes the dataset as a whole
    # def process_dataset(set)
    #   set
    # end
  end
end
