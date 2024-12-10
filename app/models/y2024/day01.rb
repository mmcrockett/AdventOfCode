module Y2024
  class Day01
    include FileName

    def initialize(file: nil, file_ext: nil)
      @lines = load_data(file_name(file: file, file_ext: file_ext)).map { |line| line.split(/\W+/).map(&:to_i) }
      @l = @lines.map(&:first).sort
      @r = @lines.map(&:last).sort
    end

    def part1
      @l.size.times.sum do |i|
        (@r[i] - @l[i]).abs
      end
    end

    def part2
      @r.each do |v|
        @h ||= {}
        @h[v] ||= 0
        @h[v] += 1
      end

      @l.sum do |v|
        @h[v].to_i * v
      end
    end
  end
end
