# frozen_string_literal: true

module Year2022
  class Day01 < Solution
    # @input is available if you need the raw data input
    # Call `data` to access either an array of the parsed data, or a single record for a 1-line input file

    def part_1
      total = nil
      max   = 0

      data.each do |calorie|
        if calorie.empty?
          max = total if total > max
          total = nil
        elsif total.nil?
          total = calorie.to_i
        else
          total += calorie.to_i
        end
      end

      max
    end

    def part_2
      total = nil
      totals = []

      data.each do |calorie|
        if calorie.empty?
          totals << total
          total = nil
        elsif total.nil?
          total = calorie.to_i
        else
          total += calorie.to_i
        end
      end

      totals.sort.last(3).sum
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
