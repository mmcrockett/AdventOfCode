module Y2015
  class Day10
    INPUT = '1113122113'

    # 469694 too high
    def self.look_n_say(str)
      str     = str.chars if str.respond_to?(:chars)
      new_str = []
      last_c  = str[0]
      count   = 1

      str[1..-1].each do |c|
        if c != last_c
          new_str << count << last_c
          count  = 1
        else
          count += 1
        end

        last_c = c
      end

      new_str << count << last_c

      new_str.map(&:to_s)
    end

    def self.part1(value: , limit:)
      limit.times do
        value = Day10.look_n_say(value)
      end

      value
    end

    def part1
      Y2015::Day10.part1(value: INPUT, limit: 40)
    end

    def part2
      Y2015::Day10.part1(value: INPUT, limit: 50)
    end
  end
end
