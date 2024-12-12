module Y2024
  class Day03
    include FileName

    def initialize(file: nil)
      @lines = load_data(file_name(file: file))
    end

    def part1
      # low 29369763
      @lines.sum do |line|
        line.scan(/mul\(\d+,\d+\)/).sum do |cmd|
          cmd.split(',').map {|v| v.match(/\d+/).to_s.to_i }.inject(:*)
        end
      end
    end

    def part2
      # high 97836217
      @enabled = true

      @lines.sum do |line|
        line.scan(/mul\(\d+,\d+\)|do\(\)|don't\(\)/).sum do |cmd|
          is_mul = cmd.include?('mul')

          @enabled = true if 'do()' == cmd
          @enabled = false if "don't()" == cmd

          v = cmd.split(',').map {|v| v.match(/\d+/).to_s.to_i }.inject(:*)

          (is_mul && @enabled) ? v : 0
        end
      end
    end
  end
end
