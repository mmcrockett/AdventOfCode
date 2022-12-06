# frozen_string_literal: true

module Year2022
  class Day03 < Solution
    # @input is available if you need the raw data input
    # Call `data` to access either an array of the parsed data, or a single record for a 1-line input file
    VALUES = (('a'..'z').each_with_index.map { |v, i| [v, i + 1] } + ('A'..'Z').each_with_index.map do |v, i|
                                                                       [v, i + 27]
                                                                     end).to_h

    def part_1
      data.map do |str|
        size = str.size
        i = size / 2
        a = str[0, i]
        b = str[i, i]

        (a.chars & b.chars).map { |v| VALUES[v] }.sum
      end.sum
    end

    def part_2
      group = []

      data.map do |str|
        result = 0
        group << str

        if 3 == group.size
          result = VALUES[group.map(&:chars).reduce(&:&).first]
          group = []
        end

        result
      end.sum
    end

    # def process_input(line)
    #   line.map(&:to_i)
    # end

    # Processes the dataset as a whole
    # def process_dataset(set)
    #   set
    # end
  end
end
