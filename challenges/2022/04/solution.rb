# frozen_string_literal: true

module Year2022
  class Day04 < Solution
    # @input is available if you need the raw data input
    # Call `data` to access either an array of the parsed data, or a single record for a 1-line input file

    def part_1
      data.map do |assignments|
        (left, right) = assignments

        if left.first >= right.first && left.last <= right.last
          1
        elsif right.first >= left.first && right.last <= left.last
          1
        else
          0
        end
      end.sum
    end

    def part_2
      data.map do |assignments|
        (left, right) = assignments

        if ((left.first..left.last).to_a & (right.first..right.last).to_a).empty?
          0
        else
          1
        end
      end.sum
    end

    private

    # Processes each line of the input file and stores the result in the dataset
    def process_input(line)
      line.split(',').map do |d|
        d.split('-').map(&:to_i)
      end
    end

    # Processes the dataset as a whole
    # def process_dataset(set)
    #   set
    # end
  end
end
