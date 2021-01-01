module Y2020
  class Day23
    EXAMPLE_1 = '389125467'.chars.map(&:to_i)
    INPUT = '952316487'.chars.map(&:to_i)

    def initialize(input: INPUT)
      @max = input.max
      @min = input.min
      @input = input
    end

    def part1(moves: 100, debug: false)
      input = @input.dup

      moves.times do
        new_v   = input[0] - 1
        pick_up = input[1..3]
        input   = [input[0]] + input[4..-1]
        new_v   = @max if new_v < @min

        while pick_up.include?(new_v)
          new_v -= 1
          new_v  = @max if new_v < @min
        end

        new_i = input.index(new_v)

        input = input[0..new_i] + pick_up + input[new_i + 1..-1]
        input = input.rotate
      end

      while (1 != input[0])
        input = input.rotate
      end

      input[1..-1].join
    end

    def display(list, start_v)
      puts
      print "#{start_v}"

      (list.size - 1).times do
        print " #{list[start_v]}"
        start_v = list[start_v]
      end
    end

    def part2(moves: 10_000_000, debug: false, max: 1_000_000)
      list   = {}
      next_v = @input[0]

      (0..max - 1).each do |i|
        ii = @input[i] || i + 1
        ix = @input[i + 1] || (i + 2)

        ix = @input[0] if ix > max

        list[ii] = ix
      end

      moves.times do |t|
        puts "#{t}" if (t % 100_000).zero?
        start_v = next_v
        new_v = next_v - 1
        new_v = max if new_v < @min

        pick_up = []

        while pick_up.size < 3
          pick_up << list[next_v]
          next_v  = pick_up.last
        end

        while pick_up.include?(new_v)
          new_v -= 1
          new_v  = max if new_v < @min
        end

        list[start_v] = list[pick_up.last]
        list[pick_up.last] = list[new_v]
        list[new_v]   = pick_up.first
        next_v = list[start_v]
      end

      [list[1], list[list[1]]]
    end
  end
end
