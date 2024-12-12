module Y2024
  class Day04
    include FileName

    def initialize(file: nil)
      @lines = load_data(file_name(file: file))
      @h_lines = @lines.map(&:chars) # 3
      @hr_lines = @h_lines.map(&:reverse) # 2
      @v_lines = @lines.size.times.map do |i|
        @h_lines.map {|line| line[i] }
      end # 1
      @fx_lines = []
      @bx_lines = []
      (@lines.size - 3).times.each do |i|
        (@lines.size - 3).times.each do |j|
          @fx_lines << (0..3).map {|d| @h_lines[i + d][j + d] }
          @bx_lines << (0..3).map {|d| @hr_lines[i + d][j + d] }
        end
      end
    end

    def part1
      (@h_lines + @v_lines + @fx_lines + @bx_lines).sum do |line|
        str = line.join('')

        str.scan(/XMAS/).count + str.reverse.scan(/XMAS/).count
      end
    end

    def part2
      count = 0

      @h_lines.size.times do |i|
        next if i.zero? || @h_lines[i + 1].nil?
        @h_lines.size.times do |j|
          next if j.zero? || @h_lines[i][j + 1].nil?
          next if 'A' != @h_lines[i][j]

          c0 = @h_lines[i - 1][j - 1]
          c1 = @h_lines[i + 1][j - 1]
          c2 = @h_lines[i - 1][j + 1]
          c3 = @h_lines[i + 1][j + 1]

          next if [c0, c1, c2, c3].count {|ch| ch == 'S' } != 2 || [c0, c1, c2, c3].count {|ch| ch == 'M' } != 2
          next if c0 == c3 || c1 == c2
          count += 1
        end
      end

      count
    end
  end
end

