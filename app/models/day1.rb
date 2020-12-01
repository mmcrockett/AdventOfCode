class Day1
  def initialize
    @lines = File.open(Rails.root.join('test', 'fixtures', 'files', 'day1.txt')).each_line.map(&:chomp)
  end

  def part1
    @lines.size.times do | i|
      (i + 1..@lines.size).each do |j|
        a = @lines[i].to_i
        b = @lines[j].to_i

        sum = a + b

        return a * b if 2020 == sum
      end
    end
  end

  def part2
    @lines.size.times do | i|
      (i + 1..@lines.size).each do |j|
        (j + 1..@lines.size).each do |k|
          a = @lines[i].to_i
          b = @lines[j].to_i
          c = @lines[k].to_i

          sum = a + b + c

          return a * b * c if 2020 == sum
        end
      end
    end
  end
end
