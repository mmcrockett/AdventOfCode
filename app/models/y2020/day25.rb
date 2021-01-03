module Y2020
  class Day25
    EXAMPLE_1 = [5764801, 17807724]
    INPUT = [12090988, 240583]
    DIV_VALUE = 20201227

    def initialize(input = INPUT)
      @input = input
    end

    def transform(v, subject_number: 7)
      (v * subject_number) % DIV_VALUE
    end

    def part1
      result = @input.map do |v|
        i = 0
        t = 1

        while v != t
          t = transform(t)
          i += 1
        end

        i
      end

      result.each_with_index.map do |loop_value, i|
        sn = @input.reverse[i]
        v  = 1

        loop_value.times do
          v = transform(v, subject_number: sn)
        end

        v
      end
    end
  end
end
