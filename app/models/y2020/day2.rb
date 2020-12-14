module Y2020
  class Day2
    F = Rails.root.join('test/fixtures/files/y2020/day2.txt')

    def initialize
      @data = File.open(F).each_line.map do |line|
        line = line.chomp
        (r, b) = line.split(':')
        (r, l) = r.split(' ')
        (min, max) = r.split('-')

        OpenStruct.new(
          min: min.to_i,
          max: max.to_i,
          letter: l.strip,
          password: b.strip
        )
      end
    end

    def part1
      remaining = @data.select do |d|
        without = d.password.delete(d.letter)
        count   = d.password.size - without.size

        count >= d.min && count <= d.max
      end

      remaining.size
    end

    def part2
      remaining = @data.select do |d|
        (d.password[d.min - 1] == d.letter) ^ (d.password[d.max - 1] == d.letter)
      end

      remaining.size
    end
  end
end
