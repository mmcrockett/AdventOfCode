# frozen_string_literal: true

module Year2022
  class Day05 < Solution
    # @input is available if you need the raw data input
    # Call `data` to access either an array of the parsed data, or a single record for a 1-line input file

    def part_1
      data

      @moves.each do |count, from, to|
        raise 'too few' if count > @stacks[from].size

        count.times do
          crate = @stacks[from].shift
          @stacks[to].unshift(crate)
        end
      end

      @stacks.values.map(&:first).join
    end

    def part_2
      data

      @moves.each do |count, from, to|
        raise 'too few' if count > @stacks[from].size

        crates = @stacks[from].shift(count)
        @stacks[to].unshift(*crates)
      end

      @stacks.values.map(&:first).join
    end

    private

    def process_input(line)
      @moves = [] if line.empty?
      return if line.empty?

      if @moves.nil?
        process_stack(line)
      else
        @moves << line.scan(/\d+/).map(&:to_i)
      end
    end

    def process_stack(line)
      return unless line.include?('[')

      @stacks ||= {}
      i = 1

      while i < line.size
        s_i = (i / 4) + 1
        @stacks[s_i] ||= []
        @stacks[s_i] << line[i] unless line[i].strip.empty?
        i += 4
      end
    end

    # Processes the dataset as a whole
    # def process_dataset(set)
    #   set
    # end
  end
end
