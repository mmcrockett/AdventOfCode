class String
  BAD_CHARS = %w[i o l].freeze

  def advent_valid?
    recent     = []
    dup_match  = []
    trip_match = false

    self.chars do |c|
      return false if c.in?(BAD_CHARS)

      recent << c

      if dup_match.size < 2 && recent.size > 1 && recent[-1] == recent[-2]
        s = "#{recent[-2]}#{recent[-1]}"
        dup_match << s unless s.in?(dup_match)
      end

      if false == trip_match && recent.size > 2 && recent[-3].next == recent[-2] && recent[-2].next == recent[-1]
        trip_match = true
      end
    end

    trip_match && dup_match.size >= 2
  end
end

module Y2015
  class Day11
    INPUT = 'hxbxwxba'

    def self.next_password(str)
      while false == str.advent_valid?
        str = str.next
      end

      str
    end

    def part1
      Y2015::Day11.next_password(INPUT)
    end

    def part2
      answer = Y2015::Day11.next_password(INPUT)
      Y2015::Day11.next_password(answer.next)
    end
  end
end
