require 'test_helper'

class Day11Test < ActiveSupport::TestCase
  PUZZLE_FILE = "#{self.name.underscore}.txt"

  let(:code) {
    robot = ElfComputer.new([], input_data, loop_mode: true)
    dir   = :n
    loc   = [0, 0]
    tiles = {}

    while (false == robot.halted?)
      color = tiles[loc] || input.shift.to_i

      new_color = robot.run(color).output.last
      break if new_color.nil?
      new_dir   = robot.run.output.last
      raise if new_dir.nil?

      tiles[loc] = new_color

      if (0 == new_dir && :n == dir) || (1 == new_dir && :s == dir)
        loc = [loc.first - 1, loc.last]
        dir = :w
      elsif (0 == new_dir && :s == dir) || (1 == new_dir && :n == dir)
        loc = [loc.first + 1, loc.last]
        dir = :e
      elsif (0 == new_dir && :w == dir) || (1 == new_dir && :e == dir)
        loc = [loc.first, loc.last - 1]
        dir = :s
      elsif (0 == new_dir && :e == dir) || (1 == new_dir && :w == dir)
        loc = [loc.first, loc.last + 1]
        dir = :n
      else
        raise "Unknown d change #{new_dir}:#{dir}"
      end
    end

    tiles
  }

  describe 'part 1' do
    describe 'solution' do
      let(:data) { puzzle }
      let(:input) { [] }

      it 'works' do
        assert_equal(2219, code.size)
      end
    end
  end

  describe 'part 2' do
    describe 'solution' do
      let(:data) { puzzle }
      let(:input) { [1] }

      it 'works' do
        results = []
        tiles   = code.freeze
        min_x   = tiles.keys.map {|k| k.first}.min
        max_x   = tiles.keys.map {|k| k.first}.max
        min_y   = tiles.keys.map {|k| k.last}.min
        max_y   = tiles.keys.map {|k| k.last}.max

        (min_y..max_y).to_a.reverse.each do |y|
          puts ''

          (min_x..max_x).each do |x|
            color = tiles[[x,y]] || 0

            print ' ' if 0 == color
            print '#' if 1 == color
          end
        end
      end
    end
  end

  let(:puzzle) { read_test_file(File.join('aoc', PUZZLE_FILE)) }
  let(:input_data) { data.split(',').map(&:to_i) }
end
