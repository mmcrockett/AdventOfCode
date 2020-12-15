module Y2020
  class Day15
    INPUT = '0,20,7,16,1,18,15'
    EXAMPLE = '0,3,6'

    def initialize(input = INPUT)
      @data = input.split(',').map(&:to_i)
    end

    def part1(n = 2020)
      last_spoken = {}
      speak       = nil
      next_speak  = nil

      n.times do |i|
        if i < @data.size
          speak = @data[i]
        else
          speak = next_speak
        end

        #debugger unless @q.nil?

        #puts "#{speak}"

        next_speak = last_spoken[speak].nil? ? 0 : i - last_spoken[speak]

        last_spoken[speak] = i
      end

      speak
    end
  end
end
