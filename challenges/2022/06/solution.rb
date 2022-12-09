# frozen_string_literal: true

module Year2022
  class Day06 < Solution
    # @input is available if you need the raw data input
    # Call `data` to access either an array of the parsed data, or a single record for a 1-line input file

    def part_1
      d = data
      i = 3

      while i < d.size
        return i + 4 if d[i, 4].chars.uniq.size == 4

        i += 1
      end
    end

    def part_2
      d = data
      i = 3

      while i < d.size
        return i + 14 if d[i, 14].chars.uniq.size == 14

        i += 1
      end
    end

    # Processes each line of the input file and stores the result in the dataset
    # def process_input(line)
    #   line.map(&:to_i)
    # end

    # Processes the dataset as a whole
    # def process_dataset(set)
    #   set
    # end
  end
end
