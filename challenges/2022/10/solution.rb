# frozen_string_literal: true

class Cmd
  def initialize(str)
    @str = str
  end

  def call(v)
    # if (@str.include?('noop'))
  end
end

module Year2022
  class Day10 < Solution
    # @input is available if you need the raw data input
    # Call `data` to access either an array of the parsed data, or a single record for a 1-line input file

    def part_1
      scores = []
      x = 1

      data.flatten.each_with_index do |f, i|
        scores << x * (i + 1) if 20 == ((i + 1) % 40)

        x = f.call(x)
      end

      scores.sum
    end

    def part_2
      x = 1

      puts ''
      puts '=' * 40
      data.flatten.each_with_index do |f, i|
        ix = i % 40
        c = [x - 1, x, x + 1].include?(ix) ? '#' : '.'
        puts '' if ix.zero?
        # debugger
        print(c)

        x = f.call(x)
      end

      puts ''
      puts '=' * 40
      'plefulpb'
    end

    # Processes each line of the input file and stores the result in the dataset
    def process_input(line)
      noop = ->(v) { v }
      return noop if line.include?('noop')

      [noop, ->(v) { v + line.split.last.to_i }]
    end

    # Processes the dataset as a whole
    # def process_dataset(set)
    #   set
    # end
  end
end
