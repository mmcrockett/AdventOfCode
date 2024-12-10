module Y2024
  class Day02
    include FileName

    def initialize(file: nil)
      @lines = load_data(file_name(file: file)).map { |line| line.split(/\W+/).map(&:to_i) }
    end

    def grouped_by_part1_status
      @grouped ||= @lines.group_by do |line|
        direction = nil

        line.each_cons(2).all? do |v0, v1|
          diff = (v0 - v1)
          direction = diff.positive? if direction.nil?

          false == diff.zero? && diff.abs <= 3 && direction == diff.positive?
        end
      end
    end

    def part1
      grouped_by_part1_status[true].size
    end

    def part2
      grouped_by_part1_status[false].select do |line|
        line.combination(line.size - 1).any? do |subset|
          direction = nil

          subset.each_cons(2).all? do |v0, v1|
            diff = (v0 - v1)
            direction = diff.positive? if direction.nil?

            false == diff.zero? && diff.abs <= 3 && direction == diff.positive?
          end
        end
      end.size + part1
    end
  end
end
