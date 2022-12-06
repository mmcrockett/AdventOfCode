# frozen_string_literal: true

require('./challenges/shared/rps_match')
require('./challenges/shared/rps_match_2')

module Year2022
  class Day02 < Solution
    # @input is available if you need the raw data input
    # Call `data` to access either an array of the parsed data, or a single record for a 1-line input file
    def part_1
      score = 0

      data.each do |other, me|
        score += RpsMatch.new(other, me).total_score
      end

      score
    end

    def part_2
      score = 0

      data.each do |other, me|
        score += RpsMatch2.new(other, me).total_score
      end

      score
    end

    private

    # Processes each line of the input file and stores the result in the dataset
    def process_input(line)
      line.split(' ')
    end

    # Processes the dataset as a whole
    # def process_dataset(set)
    #   set
    # end
  end
end
