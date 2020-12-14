module Y2020
  class Day9
    # LOW 1631469
    include FileName

    PART1_ANSWER = 14360655

    def initialize(file: nil, file_ext: nil, preamble_size: 25)
      @data     = load_data(file_name(file: file, file_ext: file_ext))
      @preamble_size = preamble_size
    end

    def load_data(file)
      File.open(file).each_line.map(&:chomp).map(&:to_i)
    end

    def part1
      data     = @data.dup
      preamble = data.shift(@preamble_size)

      data.each do |n|
        sums = preamble.combination(2).map(&:sum)

        return n if sums.exclude?(n)
        preamble.shift
        preamble << n
      end
    end

    def part2(part1_answer = PART1_ANSWER)
      data = @data.dup

      while data.present?
        tuple = [data.shift]

        next if tuple.sum > part1_answer

        data.each do |v|
          tuple << v
          break if tuple.sum >= part1_answer
        end

        return tuple if tuple.size > 1 && tuple.sum == part1_answer
      end
    end

    def part2_answer(result)
      result.min + result.max
    end
  end
end
